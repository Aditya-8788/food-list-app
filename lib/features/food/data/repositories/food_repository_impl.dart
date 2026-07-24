// TODO: Implement food repository implementation.
import '../../domain/entities/food_entity.dart';
import '../../domain/repositories/food_repository.dart';
import '../datasource/food_remote_datasource.dart';
import '../models/food_model.dart';

class FoodRepositoryImpl implements FoodRepository {
  final FoodRemoteDataSource remoteDataSource;

  FoodRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addFood(FoodEntity food) {
    return remoteDataSource.addFood(FoodModel.fromEntity(food));
  }

  @override
  Future<void> updateFood(FoodEntity food) {
    return remoteDataSource.updateFood(FoodModel.fromEntity(food));
  }

  @override
  Future<void> deleteFood(String foodId) {
    return remoteDataSource.deleteFood(foodId);
  }

  @override
  Future<List<FoodEntity>> getAllFoods() {
    return remoteDataSource.getAllFoods();
  }

  @override
  Future<List<FoodEntity>> getHotelFoods(String ownerId) {
    return remoteDataSource.getHotelFoods(ownerId);
  }
}