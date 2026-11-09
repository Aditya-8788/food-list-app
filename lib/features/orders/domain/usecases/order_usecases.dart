import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class PlaceOrderUseCase {
  final OrderRepository repository;

  PlaceOrderUseCase(this.repository);

  Future<String> call(OrderEntity order) => repository.placeOrder(order);
}

class WatchCustomerOrdersUseCase {
  final OrderRepository repository;

  WatchCustomerOrdersUseCase(this.repository);

  Stream<List<OrderEntity>> call(String customerId) =>
      repository.watchCustomerOrders(customerId);
}

class WatchHotelOrdersUseCase {
  final OrderRepository repository;

  WatchHotelOrdersUseCase(this.repository);

  Stream<List<OrderEntity>> call(String hotelOwnerId) =>
      repository.watchHotelOrders(hotelOwnerId);
}

class WatchOrderUseCase {
  final OrderRepository repository;

  WatchOrderUseCase(this.repository);

  Stream<OrderEntity?> call(String orderId) => repository.watchOrder(orderId);
}

class UpdateOrderStatusUseCase {
  final OrderRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  Future<void> call(String orderId, String status) =>
      repository.updateOrderStatus(orderId, status);
}
