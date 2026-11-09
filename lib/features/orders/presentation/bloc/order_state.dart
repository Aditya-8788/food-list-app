import 'package:equatable/equatable.dart';

import '../../domain/entities/order_entity.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class OrderLoading extends OrderState {
  const OrderLoading();
}

class OrderLoaded extends OrderState {
  final List<OrderEntity> orders;

  const OrderLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderEmpty extends OrderState {
  const OrderEmpty();
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}
