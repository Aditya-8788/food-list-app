import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fooddelivery/features/food/domain/entities/food_entity.dart';
import 'package:fooddelivery/features/food/presentation/widgets/food_card.dart';

void main() {
  testWidgets('FoodCard shows a circular avatar with the item number', (
    WidgetTester tester,
  ) async {
    final food = FoodEntity(
      id: '1',
      hotelId: 'hotel_1',
      ownerId: 'owner_1',
      name: 'Burger',
      description: 'Tasty burger',
      price: 120,
      imageUrl: '',
      category: 'Fast Food',
      calories: 320,
      protein: 20,
      carbs: 40,
      fat: 15,
      isVeg: true,
      isAvailable: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FoodCard(food: food, onTap: () {}, itemNumber: 1),
        ),
      ),
    );

    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });
}
