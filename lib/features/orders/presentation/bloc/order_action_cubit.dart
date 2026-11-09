import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/order_usecases.dart';

abstract class OrderActionState extends Equatable {
  const OrderActionState();

  @override
  List<Object?> get props => [];
}

class OrderActionIdle extends OrderActionState {
  const OrderActionIdle();
}

class OrderActionInProgress extends OrderActionState {
  const OrderActionInProgress();
}

class OrderActionSuccess extends OrderActionState {
  final String message;
  final String? orderId;

  const OrderActionSuccess(this.message, {this.orderId});

  @override
  List<Object?> get props => [message, orderId];
}

class OrderActionFailure extends OrderActionState {
  final String message;

  const OrderActionFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// One-off order actions: placing an order and changing its status.
class OrderActionCubit extends Cubit<OrderActionState> {
  final PlaceOrderUseCase placeOrderUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;

  OrderActionCubit({
    required this.placeOrderUseCase,
    required this.updateOrderStatusUseCase,
  }) : super(const OrderActionIdle());

  Future<void> placeOrder(OrderEntity order) async {
    emit(const OrderActionInProgress());
    try {
      final id = await placeOrderUseCase(order);
      emit(OrderActionSuccess('Order placed successfully', orderId: id));
    } catch (e) {
      emit(OrderActionFailure(_message(e)));
    }
  }

  Future<void> updateStatus(String orderId, String status) async {
    emit(const OrderActionInProgress());
    try {
      await updateOrderStatusUseCase(orderId, status);
      emit(OrderActionSuccess('Order marked as $status', orderId: orderId));
    } catch (e) {
      emit(OrderActionFailure(_message(e)));
    }
  }
}

/// Readable text for an error thrown while placing/updating an order.
String _message(Object error) {
  if (error is ServerException) return error.message;
  final text = error.toString();
  return text.startsWith('Exception: ') ? text.substring(11) : text;
}
