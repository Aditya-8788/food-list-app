import 'package:flutter/material.dart';

import '../../../../core/utils/helpers.dart';
import '../../domain/entities/food_entity.dart';

class FoodCard extends StatelessWidget {
  final FoodEntity food;
  final VoidCallback onTap;
  final int itemNumber;

  /// Optional control (e.g. an add-to-cart button) shown under the price.
  final Widget? action;

  const FoodCard({
    super.key,
    required this.food,
    required this.onTap,
    this.itemNumber = 1,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: primary.withValues(alpha: 0.1),
                child: Text(
                  itemNumber.toString(),
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: food.isVeg ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            food.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${food.calories.toStringAsFixed(0)} kcal · '
                      'Protein ${food.protein.toStringAsFixed(0)}g'
                      '${food.category.isNotEmpty ? ' · ${food.category}' : ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Helpers.currency(food.price),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  action ??
                      Text(
                        food.isAvailable ? 'Available' : 'Unavailable',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: food.isAvailable ? Colors.green : Colors.grey,
                        ),
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
