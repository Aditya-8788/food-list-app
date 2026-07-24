// TODO: Implement food card widget.
import 'package:flutter/material.dart';

import '../../domain/entities/food_entity.dart';

class FoodCard extends StatelessWidget {
  final FoodEntity food;
  final VoidCallback onTap;
  final int itemNumber;

  const FoodCard({
    super.key,
    required this.food,
    required this.onTap,
    this.itemNumber = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: const Color.fromARGB(255, 251, 239, 239),
          child: Text(
            itemNumber.toString(),
            style: const TextStyle(
              color: Color.fromARGB(255, 241, 42, 42),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        title: Text(
          food.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${food.calories} kcal | Protein ${food.protein}g',
        ),
        trailing: Text(
          '₹${food.price}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xffFF6B6B),
          ),
        ),
      ),
    );
  }
}