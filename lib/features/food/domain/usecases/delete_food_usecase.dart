// TODO: Implement delete food use case.
import '../repositories/food_repository.dart';

class DeleteFoodUseCase {
  final FoodRepository repository;

  DeleteFoodUseCase(this.repository);

  Future<void> call(String foodId) {
    return repository.deleteFood(foodId);
  }
}