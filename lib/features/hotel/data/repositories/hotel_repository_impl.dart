// TODO: Implement hotel repository implementation.
import '../../domain/entities/hotel_entity.dart';
import '../../domain/repositories/hotel_repository.dart';
import '../datasource/hotel_remote_datasource.dart';
import '../models/hotel_model.dart';

class HotelRepositoryImpl implements HotelRepository {
  final HotelRemoteDataSource remoteDataSource;

  HotelRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createHotelProfile(HotelEntity hotel) {
    return remoteDataSource.createHotelProfile(
      HotelModel.fromEntity(hotel),
    );
  }

  @override
  Future<HotelEntity?> getHotelProfile(String ownerId) {
    return remoteDataSource.getHotelProfile(ownerId);
  }

  @override
  Future<void> updateHotelProfile(HotelEntity hotel) {
    return remoteDataSource.updateHotelProfile(
      HotelModel.fromEntity(hotel),
    );
  }
}