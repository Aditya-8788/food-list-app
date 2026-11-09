import 'package:equatable/equatable.dart';

/// Lifecycle of a food order, in the order it moves through.
class OrderStatus {
  OrderStatus._();

  static const placed = 'Placed';
  static const confirmed = 'Confirmed';
  static const preparing = 'Preparing';
  static const outForDelivery = 'Out for Delivery';
  static const delivered = 'Delivered';
  static const cancelled = 'Cancelled';

  /// Normal progression shown on the tracking timeline.
  static const flow = [placed, confirmed, preparing, outForDelivery, delivered];

  /// The status that follows [status], or null when there is none.
  static String? next(String status) {
    final index = flow.indexOf(status);
    if (index == -1 || index == flow.length - 1) return null;
    return flow[index + 1];
  }

  static bool isActive(String status) =>
      status != delivered && status != cancelled;
}

class OrderItemEntity extends Equatable {
  final String foodId;
  final String name;
  final double price;
  final int quantity;
  final bool isVeg;

  const OrderItemEntity({
    required this.foodId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.isVeg,
  });

  double get total => price * quantity;

  @override
  List<Object?> get props => [foodId, name, price, quantity, isVeg];
}

class OrderStatusUpdate extends Equatable {
  final String status;
  final DateTime time;

  const OrderStatusUpdate({required this.status, required this.time});

  @override
  List<Object?> get props => [status, time];
}

class OrderEntity extends Equatable {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final String hotelId;
  final String hotelOwnerId;
  final String hotelName;
  final List<OrderItemEntity> items;
  final double totalAmount;
  final String status;
  final DateTime placedAt;
  final List<OrderStatusUpdate> timeline;

  const OrderEntity({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.hotelId,
    required this.hotelOwnerId,
    required this.hotelName,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.placedAt,
    required this.timeline,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Short human friendly order number derived from the document id.
  String get shortId =>
      id.length > 6 ? id.substring(0, 6).toUpperCase() : id.toUpperCase();

  DateTime? timeOf(String status) {
    for (final update in timeline) {
      if (update.status == status) return update.time;
    }
    return null;
  }

  @override
  List<Object?> get props => [
    id,
    customerId,
    customerName,
    customerPhone,
    deliveryAddress,
    hotelId,
    hotelOwnerId,
    hotelName,
    items,
    totalAmount,
    status,
    placedAt,
    timeline,
  ];
}
