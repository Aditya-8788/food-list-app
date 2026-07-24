// TODO: Define hotel events.
import 'package:equatable/equatable.dart';

import '../../domain/entities/hotel_entity.dart';

abstract class HotelEvent extends Equatable {
  const HotelEvent();

  @override
  List<Object?> get props => [];
}

class GetHotelProfileRequested extends HotelEvent {
  final String ownerId;

  const GetHotelProfileRequested(this.ownerId);

  @override
  List<Object?> get props => [ownerId];
}

class CreateHotelProfileRequested extends HotelEvent {
  final HotelEntity hotel;

  const CreateHotelProfileRequested(this.hotel);

  @override
  List<Object?> get props => [hotel];
}

class UpdateHotelProfileRequested extends HotelEvent {
  final HotelEntity hotel;

  const UpdateHotelProfileRequested(this.hotel);

  @override
  List<Object?> get props => [hotel];
}