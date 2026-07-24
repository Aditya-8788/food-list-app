// TODO: Implement customer remote data source.
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/customer_model.dart';

abstract class CustomerRemoteDataSource {
  Future<CustomerModel> getCustomerProfile(String uid);

  Future<void> updateCustomerProfile({
    required String uid,
    required String name,
    required String phone,
    required String address,
  });
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final FirebaseFirestore firestore;

  CustomerRemoteDataSourceImpl({
    required this.firestore,
  });

  @override
  Future<CustomerModel> getCustomerProfile(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      throw Exception('Customer profile not found');
    }

    return CustomerModel.fromFirestore(doc);
  }

  @override
  Future<void> updateCustomerProfile({
    required String uid,
    required String name,
    required String phone,
    required String address,
  }) async {
    await firestore.collection('users').doc(uid).update({
      'name': name,
      'phone': phone,
      'address': address,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}