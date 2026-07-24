import 'package:flutter/material.dart';

import '../../domain/entities/food_entity.dart';
import '../widgets/nutrition_info_card.dart';

class FoodDetailsPage extends StatelessWidget {
  final FoodEntity food;

  const FoodDetailsPage({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(food.name),
        backgroundColor: const Color(0xffFF6B6B),
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffFF6B6B),
              Color(0xffFF8E53),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (food.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    // child: Image.network(
                    //   food.imageUrl,
                    //   height: 220,
                    //   width: double.infinity,
                    //   fit: BoxFit.cover,
                    // ),
                  )
                else
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.fastfood, size: 80),
                  ),

                const SizedBox(height: 20),

                Text(
                  food.name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  food.description,
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 12),

                Text(
                  '₹${food.price}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffFF6B6B),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Nutrition Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    NutritionInfoCard(
                      title: 'Calories',
                      value: '${food.calories}',
                    ),
                    NutritionInfoCard(
                      title: 'Protein',
                      value: '${food.protein}g',
                    ),
                    NutritionInfoCard(
                      title: 'Carbs',
                      value: '${food.carbs}g',
                    ),
                    NutritionInfoCard(
                      title: 'Fat',
                      value: '${food.fat}g',
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Chip(
                      label: Text(food.isVeg ? 'Veg' : 'Non-Veg'),
                      backgroundColor:
                          food.isVeg ? Colors.green.shade100 : Colors.red.shade100,
                    ),
                    const SizedBox(width: 12),
                    Chip(
                      label: Text(food.isAvailable ? 'Available' : 'Unavailable'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}