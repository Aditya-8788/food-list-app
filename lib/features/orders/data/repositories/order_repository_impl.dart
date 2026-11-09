import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasource/order_remote_datasource.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> placeOrder(OrderEntity order) {
    return remoteDataSource.placeOrder(OrderModel.fromEntity(order));
  }

  @override
  Stream<List<OrderEntity>> watchCustomerOrders(String customerId) {
    return remoteDataSource.watchCustomerOrders(customerId);
  }

  @override
  Stream<List<OrderEntity>> watchHotelOrders(String hotelOwnerId) {
    return remoteDataSource.watchHotelOrders(hotelOwnerId);
  }

  @override
  Stream<OrderEntity?> watchOrder(String orderId) {
    return remoteDataSource.watchOrder(orderId);
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) {
    return remoteDataSource.updateOrderStatus(orderId, status);
  }
}
