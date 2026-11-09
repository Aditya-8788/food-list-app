import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/order_entity.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  /// Saves a new order and returns its generated id.
  Future<String> placeOrder(OrderModel order);

  Stream<List<OrderModel>> watchCustomerOrders(String customerId);

  Stream<List<OrderModel>> watchHotelOrders(String hotelOwnerId);

  Stream<OrderModel?> watchOrder(String orderId);

  Future<void> updateOrderStatus(String orderId, String status);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore firestore;

  OrderRemoteDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _orders =>
      firestore.collection(FirestoreCollections.orders);

  @override
  Future<String> placeOrder(OrderModel order) async {
    var hotelName = order.hotelName;
    Map<String, dynamic>? hotel;

    // Resolve the restaurant so both sides see its name on the order.
    if (order.hotelId.isNotEmpty) {
      try {
        final hotelDoc = await firestore
            .collection(FirestoreCollections.hotels)
            .doc(order.hotelId)
            .get();
        hotel = hotelDoc.data();
        hotelName = hotel?['hotelName']?.toString() ?? hotelName;
      } catch (_) {
        // Keep the fallback name if the hotel lookup fails.
      }
    }

    // Respect the owner's "Hotel Open" switch.
    if (hotel?['isOpen'] == false) {
      throw ServerException(
        '$hotelName is closed right now. Please try again later.',
      );
    }

    final docRef = _orders.doc();
    await docRef.set({
      ...order.toFirestore(),
      'hotelName': hotelName,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  // Sorted client-side so no composite Firestore index is required.
  List<OrderModel> _sorted(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final orders = snapshot.docs.map(OrderModel.fromFirestore).toList();
    orders.sort((a, b) => b.placedAt.compareTo(a.placedAt));
    return orders;
  }

  @override
  Stream<List<OrderModel>> watchCustomerOrders(String customerId) {
    return _orders
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .map(_sorted);
  }

  @override
  Stream<List<OrderModel>> watchHotelOrders(String hotelOwnerId) {
    return _orders
        .where('hotelOwnerId', isEqualTo: hotelOwnerId)
        .snapshots()
        .map(_sorted);
  }

  @override
  Stream<OrderModel?> watchOrder(String orderId) {
    return _orders
        .doc(orderId)
        .snapshots()
        .map((doc) => doc.exists ? OrderModel.fromFirestore(doc) : null);
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _orders.doc(orderId).update({
      'status': status,
      'timeline': FieldValue.arrayUnion([
        OrderModel.statusUpdateToMap(
          OrderStatusUpdate(status: status, time: DateTime.now()),
        ),
      ]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
