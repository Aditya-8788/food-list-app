// TODO: Define hotel repository contract.
import '../entities/hotel_entity.dart';

abstract class HotelRepository {
  Future<void> createHotelProfile(HotelEntity hotel);

  Future<HotelEntity?> getHotelProfile(String ownerId);

  Future<void> updateHotelProfile(HotelEntity hotel);
}