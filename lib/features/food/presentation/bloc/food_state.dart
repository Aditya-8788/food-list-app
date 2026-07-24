// TODO: Define food states.
import 'package:equatable/equatable.dart';

import '../../domain/entities/food_entity.dart';

abstract class FoodState extends Equatable {
  const FoodState();

  @override
  List<Object?> get props => [];
}

class FoodInitial extends FoodState {}

class FoodLoading extends FoodState {}

class FoodLoaded extends FoodState {
  final List<FoodEntity> foods;

  const FoodLoaded(this.foods);

  @override
  List<Object?> get props => [foods];
}

class FoodActionSuccess extends FoodState {
  final String message;

  const FoodActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class FoodError extends FoodState {
  final String message;

  const FoodError(this.message);

  @override
  List<Object?> get props => [message];
}