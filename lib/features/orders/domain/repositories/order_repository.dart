import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<String> placeOrder(OrderEntity order);

  Stream<List<OrderEntity>> watchCustomerOrders(String customerId);

  Stream<List<OrderEntity>> watchHotelOrders(String hotelOwnerId);

  Stream<OrderEntity?> watchOrder(String orderId);

  Future<void> updateOrderStatus(String orderId, String status);
}
