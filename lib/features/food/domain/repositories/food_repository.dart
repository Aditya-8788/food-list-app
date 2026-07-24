// TODO: Define food repository contract.
import '../entities/food_entity.dart';

abstract class FoodRepository {
  Future<void> addFood(FoodEntity food);

  Future<void> updateFood(FoodEntity food);

  Future<void> deleteFood(String foodId);

  Future<List<FoodEntity>> getAllFoods();

  Future<List<FoodEntity>> getHotelFoods(String ownerId);
}