import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

/// Start live tracking of all orders placed by a customer.
class WatchCustomerOrdersRequested extends OrderEvent {
  final String customerId;

  const WatchCustomerOrdersRequested(this.customerId);

  @override
  List<Object?> get props => [customerId];
}

/// Start live tracking of all orders received by a hotel owner.
class WatchHotelOrdersRequested extends OrderEvent {
  final String hotelOwnerId;

  const WatchHotelOrdersRequested(this.hotelOwnerId);

  @override
  List<Object?> get props => [hotelOwnerId];
}
