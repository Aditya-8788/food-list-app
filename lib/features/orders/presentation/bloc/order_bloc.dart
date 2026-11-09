import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/order_usecases.dart';
import 'order_event.dart';
import 'order_state.dart';

/// Streams a live list of orders from Firestore (real-time tracking).
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final WatchCustomerOrdersUseCase watchCustomerOrders;
  final WatchHotelOrdersUseCase watchHotelOrders;

  OrderBloc({required this.watchCustomerOrders, required this.watchHotelOrders})
    : super(const OrderInitial()) {
    on<WatchCustomerOrdersRequested>(
      (event, emit) => _watch(watchCustomerOrders(event.customerId), emit),
    );
    on<WatchHotelOrdersRequested>(
      (event, emit) => _watch(watchHotelOrders(event.hotelOwnerId), emit),
    );
  }

  Future<void> _watch(
    Stream<List<OrderEntity>> stream,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());

    await emit.forEach<List<OrderEntity>>(
      stream,
      onData: (orders) =>
          orders.isEmpty ? const OrderEmpty() : OrderLoaded(orders),
      onError: (error, _) => OrderError(error.toString()),
    );
  }
}
