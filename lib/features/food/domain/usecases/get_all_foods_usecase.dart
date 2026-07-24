import '../entities/food_entity.dart';
import '../repositories/food_repository.dart';

class GetAllFoodsUseCase {
  final FoodRepository repository;

  GetAllFoodsUseCase(this.repository);

  Future<List<FoodEntity>> call() {
    return repository.getAllFoods();
  }
}