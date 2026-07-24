// TODO: Implement update food use case.
import '../entities/food_entity.dart';
import '../repositories/food_repository.dart';

class UpdateFoodUseCase {
  final FoodRepository repository;

  UpdateFoodUseCase(this.repository);

  Future<void> call(FoodEntity food) {
    return repository.updateFood(food);
  }
}