// TODO: Implement food BLoC.
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_food_usecase.dart';
import '../../domain/usecases/delete_food_usecase.dart';
import '../../domain/usecases/get_all_foods_usecase.dart';
import '../../domain/usecases/get_hotel_foods_usecase.dart';
import '../../domain/usecases/update_food_usecase.dart';
import 'food_event.dart';
import 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final AddFoodUseCase addFoodUseCase;
  final UpdateFoodUseCase updateFoodUseCase;
  final DeleteFoodUseCase deleteFoodUseCase;
  final GetAllFoodsUseCase getAllFoodsUseCase;
  final GetHotelFoodsUseCase getHotelFoodsUseCase;

  FoodBloc({
    required this.addFoodUseCase,
    required this.updateFoodUseCase,
    required this.deleteFoodUseCase,
    required this.getAllFoodsUseCase,
    required this.getHotelFoodsUseCase,
  }) : super(FoodInitial()) {
    on<AddFoodRequested>(_onAddFood);
    on<UpdateFoodRequested>(_onUpdateFood);
    on<DeleteFoodRequested>(_onDeleteFood);
    on<GetAllFoodsRequested>(_onGetAllFoods);
    on<GetHotelFoodsRequested>(_onGetHotelFoods);
  }

  Future<void> _onAddFood(
    AddFoodRequested event,
    Emitter<FoodState> emit,
  ) async {
    emit(FoodLoading());

    try {
      await addFoodUseCase(event.food);
      emit(const FoodActionSuccess('Food added successfully'));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }

  Future<void> _onUpdateFood(
    UpdateFoodRequested event,
    Emitter<FoodState> emit,
  ) async {
    emit(FoodLoading());

    try {
      await updateFoodUseCase(event.food);
      emit(const FoodActionSuccess('Food updated successfully'));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }

  Future<void> _onDeleteFood(
    DeleteFoodRequested event,
    Emitter<FoodState> emit,
  ) async {
    emit(FoodLoading());

    try {
      await deleteFoodUseCase(event.foodId);
      emit(const FoodActionSuccess('Food deleted successfully'));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }

  Future<void> _onGetAllFoods(
    GetAllFoodsRequested event,
    Emitter<FoodState> emit,
  ) async {
    emit(FoodLoading());

    try {
      final foods = await getAllFoodsUseCase();
      emit(FoodLoaded(foods));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }

  Future<void> _onGetHotelFoods(
    GetHotelFoodsRequested event,
    Emitter<FoodState> emit,
  ) async {
    emit(FoodLoading());

    try {
      final foods = await getHotelFoodsUseCase(event.ownerId);
      emit(FoodLoaded(foods));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }
}