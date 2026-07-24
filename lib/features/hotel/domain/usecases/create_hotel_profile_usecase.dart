// TODO: Implement create hotel profile use case.
import '../entities/hotel_entity.dart';
import '../repositories/hotel_repository.dart';

class CreateHotelProfileUseCase {
  final HotelRepository repository;

  CreateHotelProfileUseCase(this.repository);

  Future<void> call(HotelEntity hotel) {
    return repository.createHotelProfile(hotel);
  }
}