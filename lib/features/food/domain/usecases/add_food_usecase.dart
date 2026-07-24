// TODO: Implement add food use case.
import '../entities/food_entity.dart';
import '../repositories/food_repository.dart';

class AddFoodUseCase {
  final FoodRepository repository;

  AddFoodUseCase(this.repository);

  Future<void> call(FoodEntity food) {
    return repository.addFood(food);
  }
}