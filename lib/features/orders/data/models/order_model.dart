import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.customerId,
    required super.customerName,
    required super.customerPhone,
    required super.deliveryAddress,
    required super.hotelId,
    required super.hotelOwnerId,
    required super.hotelName,
    required super.items,
    required super.totalAmount,
    required super.status,
    required super.placedAt,
    required super.timeline,
  });

  factory OrderModel.fromEntity(OrderEntity order) {
    return OrderModel(
      id: order.id,
      customerId: order.customerId,
      customerName: order.customerName,
      customerPhone: order.customerPhone,
      deliveryAddress: order.deliveryAddress,
      hotelId: order.hotelId,
      hotelOwnerId: order.hotelOwnerId,
      hotelName: order.hotelName,
      items: order.items,
      totalAmount: order.totalAmount,
      status: order.status,
      placedAt: order.placedAt,
      timeline: order.timeline,
    );
  }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? const {};

    final items = (data['items'] as List? ?? const [])
        .whereType<Map>()
        .map(
          (item) => OrderItemEntity(
            foodId: item['foodId']?.toString() ?? '',
            name: item['name']?.toString() ?? '',
            price: _toDouble(item['price']),
            quantity: _toInt(item['quantity']),
            isVeg: item['isVeg'] == true,
          ),
        )
        .toList();

    final timeline = (data['timeline'] as List? ?? const [])
        .whereType<Map>()
        .map(
          (entry) => OrderStatusUpdate(
            status: entry['status']?.toString() ?? '',
            time: _toDate(entry['time']),
          ),
        )
        .toList();

    return OrderModel(
      id: doc.id,
      customerId: data['customerId']?.toString() ?? '',
      customerName: data['customerName']?.toString() ?? 'Customer',
      customerPhone: data['customerPhone']?.toString() ?? '',
      deliveryAddress: data['deliveryAddress']?.toString() ?? '',
      hotelId: data['hotelId']?.toString() ?? '',
      hotelOwnerId: data['hotelOwnerId']?.toString() ?? '',
      hotelName: data['hotelName']?.toString() ?? 'Restaurant',
      items: items,
      totalAmount: _toDouble(data['totalAmount']),
      status: data['status']?.toString() ?? OrderStatus.placed,
      placedAt: _toDate(data['placedAt']),
      timeline: timeline,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'deliveryAddress': deliveryAddress,
      'hotelId': hotelId,
      'hotelOwnerId': hotelOwnerId,
      'hotelName': hotelName,
      'items': items
          .map(
            (item) => {
              'foodId': item.foodId,
              'name': item.name,
              'price': item.price,
              'quantity': item.quantity,
              'isVeg': item.isVeg,
            },
          )
          .toList(),
      'totalAmount': totalAmount,
      'status': status,
      'placedAt': Timestamp.fromDate(placedAt),
      'timeline': timeline.map(statusUpdateToMap).toList(),
    };
  }

  static Map<String, dynamic> statusUpdateToMap(OrderStatusUpdate update) {
    return {'status': update.status, 'time': Timestamp.fromDate(update.time)};
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime _toDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
  }
}
