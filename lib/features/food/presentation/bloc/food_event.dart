// TODO: Define food events.
import 'package:equatable/equatable.dart';

import '../../domain/entities/food_entity.dart';

abstract class FoodEvent extends Equatable {
  const FoodEvent();

  @override
  List<Object?> get props => [];
}

class AddFoodRequested extends FoodEvent {
  final FoodEntity food;

  const AddFoodRequested(this.food);

  @override
  List<Object?> get props => [food];
}

class UpdateFoodRequested extends FoodEvent {
  final FoodEntity food;

  const UpdateFoodRequested(this.food);

  @override
  List<Object?> get props => [food];
}

class DeleteFoodRequested extends FoodEvent {
  final String foodId;

  const DeleteFoodRequested(this.foodId);

  @override
  List<Object?> get props => [foodId];
}

class GetAllFoodsRequested extends FoodEvent {}

class GetHotelFoodsRequested extends FoodEvent {
  final String ownerId;

  const GetHotelFoodsRequested(this.ownerId);

  @override
  List<Object?> get props => [ownerId];
}