import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../food/domain/entities/food_entity.dart';
import '../../domain/entities/order_entity.dart';

class CartItem extends Equatable {
  final FoodEntity food;
  final int quantity;

  const CartItem({required this.food, required this.quantity});

  double get total => food.price * quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(food: food, quantity: quantity ?? this.quantity);

  OrderItemEntity toOrderItem() => OrderItemEntity(
    foodId: food.id,
    name: food.name,
    price: food.price,
    quantity: quantity,
    isVeg: food.isVeg,
  );

  @override
  List<Object?> get props => [food, quantity];
}

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState([this.items = const []]);

  bool get isEmpty => items.isEmpty;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get total => items.fold(0, (sum, item) => sum + item.total);

  /// All items in a cart come from one restaurant (one order per restaurant).
  String? get hotelId => items.isEmpty ? null : items.first.food.hotelId;

  String? get hotelOwnerId => items.isEmpty ? null : items.first.food.ownerId;

  int quantityOf(String foodId) {
    for (final item in items) {
      if (item.food.id == foodId) return item.quantity;
    }
    return 0;
  }

  @override
  List<Object?> get props => [items];
}

/// In-memory cart shared across the customer screens.
class CartCubit extends Cubit<CartState> {
  static const maxQuantity = 20;

  CartCubit() : super(const CartState());

  /// True when [food] can't join the cart without clearing it first.
  bool conflictsWith(FoodEntity food) =>
      state.hotelId != null && state.hotelId != food.hotelId;

  /// Adds one [food]. Call [conflictsWith] first: food from a different
  /// restaurant replaces the current cart.
  void add(FoodEntity food) {
    if (conflictsWith(food)) {
      emit(CartState([CartItem(food: food, quantity: 1)]));
      return;
    }
    setQuantity(food, state.quantityOf(food.id) + 1);
  }

  void remove(FoodEntity food) =>
      setQuantity(food, state.quantityOf(food.id) - 1);

  void setQuantity(FoodEntity food, int quantity) {
    final clamped = quantity.clamp(0, maxQuantity);
    final items = [...state.items];
    final index = items.indexWhere((item) => item.food.id == food.id);

    if (clamped == 0) {
      if (index != -1) items.removeAt(index);
    } else if (index == -1) {
      items.add(CartItem(food: food, quantity: clamped));
    } else {
      items[index] = items[index].copyWith(quantity: clamped);
    }
    emit(CartState(items));
  }

  void clear() => emit(const CartState());
}
