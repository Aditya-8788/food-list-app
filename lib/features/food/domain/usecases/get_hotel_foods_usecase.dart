import '../entities/food_entity.dart';
import '../repositories/food_repository.dart';

class GetHotelFoodsUseCase {
  final FoodRepository repository;

  GetHotelFoodsUseCase(this.repository);

  Future<List<FoodEntity>> call(String ownerId) {
    return repository.getHotelFoods(ownerId);
  }
}