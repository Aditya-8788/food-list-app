// TODO: Implement update hotel profile use case.
import '../entities/hotel_entity.dart';
import '../repositories/hotel_repository.dart';

class UpdateHotelProfileUseCase {
  final HotelRepository repository;

  UpdateHotelProfileUseCase(this.repository);

  Future<void> call(HotelEntity hotel) {
    return repository.updateHotelProfile(hotel);
  }
}