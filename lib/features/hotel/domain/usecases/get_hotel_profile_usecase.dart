// TODO: Implement get hotel profile use case.
import '../entities/hotel_entity.dart';
import '../repositories/hotel_repository.dart';

class GetHotelProfileUseCase {
  final HotelRepository repository;

  GetHotelProfileUseCase(this.repository);

  Future<HotelEntity?> call(String ownerId) {
    return repository.getHotelProfile(ownerId);
  }
}