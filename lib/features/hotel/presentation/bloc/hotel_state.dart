// TODO: Define hotel states.
import 'package:equatable/equatable.dart';

import '../../domain/entities/hotel_entity.dart';

abstract class HotelState extends Equatable {
  const HotelState();

  @override
  List<Object?> get props => [];
}

class HotelInitial extends HotelState {}

class HotelLoading extends HotelState {}

class HotelLoaded extends HotelState {
  final HotelEntity hotel;

  const HotelLoaded(this.hotel);

  @override
  List<Object?> get props => [hotel];
}

class HotelNotCreated extends HotelState {}

class HotelActionSuccess extends HotelState {
  final String message;

  const HotelActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class HotelError extends HotelState {
  final String message;

  const HotelError(this.message);

  @override
  List<Object?> get props => [message];
}