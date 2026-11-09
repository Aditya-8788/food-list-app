import 'package:flutter_test/flutter_test.dart';

import 'package:fooddelivery/features/food/domain/entities/food_entity.dart';
import 'package:fooddelivery/features/orders/presentation/bloc/cart_cubit.dart';

FoodEntity _food(String id, {String hotelId = 'h1', double price = 100}) {
  return FoodEntity(
    id: id,
    hotelId: hotelId,
    ownerId: 'owner_$hotelId',
    name: 'Food $id',
    description: '',
    price: price,
    imageUrl: '',
    category: '',
    calories: 0,
    protein: 0,
    carbs: 0,
    fat: 0,
    isVeg: true,
    isAvailable: true,
  );
}

void main() {
  late CartCubit cart;

  setUp(() => cart = CartCubit());
  tearDown(() => cart.close());

  test('starts empty', () {
    expect(cart.state.isEmpty, isTrue);
    expect(cart.state.total, 0);
    expect(cart.state.hotelId, isNull);
  });

  test('add increments quantity and totals', () {
    final burger = _food('1', price: 120);
    final fries = _food('2', price: 80);

    cart
      ..add(burger)
      ..add(burger)
      ..add(fries);

    expect(cart.state.items.length, 2);
    expect(cart.state.quantityOf('1'), 2);
    expect(cart.state.itemCount, 3);
    expect(cart.state.total, 320);
    expect(cart.state.hotelId, 'h1');
    expect(cart.state.hotelOwnerId, 'owner_h1');
  });

  test('remove decrements and drops the item at zero', () {
    final burger = _food('1');
    cart
      ..add(burger)
      ..add(burger)
      ..remove(burger);
    expect(cart.state.quantityOf('1'), 1);

    cart.remove(burger);
    expect(cart.state.isEmpty, isTrue);
  });

  test('quantity is capped at maxQuantity', () {
    final burger = _food('1');
    cart.setQuantity(burger, 99);
    expect(cart.state.quantityOf('1'), CartCubit.maxQuantity);
  });

  test('food from another restaurant conflicts and replaces the cart', () {
    cart.add(_food('1', hotelId: 'h1'));
    final other = _food('9', hotelId: 'h2');

    expect(cart.conflictsWith(other), isTrue);
    expect(cart.conflictsWith(_food('2', hotelId: 'h1')), isFalse);

    cart.add(other);
    expect(cart.state.items.single.food.id, '9');
    expect(cart.state.hotelId, 'h2');
  });

  test('toOrderItem copies price and quantity', () {
    cart
      ..add(_food('1', price: 150))
      ..add(_food('1', price: 150));
    final item = cart.state.items.single.toOrderItem();

    expect(item.foodId, '1');
    expect(item.quantity, 2);
    expect(item.total, 300);
  });

  test('clear empties the cart', () {
    cart
      ..add(_food('1'))
      ..clear();
    expect(cart.state.isEmpty, isTrue);
  });
}
