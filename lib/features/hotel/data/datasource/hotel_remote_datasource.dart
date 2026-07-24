// TODO: Implement hotel remote data source.
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/hotel_model.dart';

abstract class HotelRemoteDataSource {
  Future<void> createHotelProfile(HotelModel hotel);

  Future<HotelModel?> getHotelProfile(String ownerId);

  Future<void> updateHotelProfile(HotelModel hotel);
}

class HotelRemoteDataSourceImpl implements HotelRemoteDataSource {
  final FirebaseFirestore firestore;

  HotelRemoteDataSourceImpl({
    required this.firestore,
  });

  @override
  Future<void> createHotelProfile(HotelModel hotel) async {
    final docRef = firestore.collection('hotels').doc();

    await docRef.set({
      ...hotel.toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<HotelModel?> getHotelProfile(String ownerId) async {
    final snapshot = await firestore
        .collection('hotels')
        .where('ownerId', isEqualTo: ownerId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return HotelModel.fromFirestore(snapshot.docs.first);
  }

  @override
  Future<void> updateHotelProfile(HotelModel hotel) async {
    await firestore.collection('hotels').doc(hotel.hotelId).update(
          hotel.toFirestore(),
        );
  }
}