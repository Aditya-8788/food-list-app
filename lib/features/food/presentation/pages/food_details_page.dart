import 'package:flutter/material.dart';

import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../orders/presentation/pages/checkout_page.dart';
import '../../domain/entities/food_entity.dart';
import '../widgets/nutrition_info_card.dart';

class FoodDetailsPage extends StatelessWidget {
  final FoodEntity food;

  /// When provided, the customer can order this food.
  final String? customerUid;

  const FoodDetailsPage({super.key, required this.food, this.customerUid});

  String _num(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final canOrder = customerUid != null && food.isAvailable;

    return Scaffold(
      appBar: AppBar(title: const Text('Food Details'), centerTitle: true),
      bottomNavigationBar: canOrder
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
                child: FilledButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CheckoutPage(customerId: customerUid!, food: food),
                    ),
                  ),
                  icon: const Icon(Icons.shopping_bag_rounded),
                  label: Text('Order Now · ${Helpers.currency(food.price)}'),
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientHeader(
              label: food.category.isEmpty ? 'Dish' : food.category,
              title: food.name,
              trailing: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fastfood_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              footer: HeaderInfoTile(
                icon: Icons.currency_rupee_rounded,
                text: Helpers.currency(food.price),
              ),
            ),
            const SizedBox(height: 20),
            SectionCard(
              child: Column(
                children: [
                  DetailRow(
                    icon: Icons.description_outlined,
                    title: 'Description',
                    value: food.description.isEmpty
                        ? 'No description'
                        : food.description,
                  ),
                  const Divider(height: 26),
                  DetailRow(
                    icon: Icons.eco_outlined,
                    title: 'Type',
                    valueWidget: _Pill(
                      text: food.isVeg ? 'Veg' : 'Non-Veg',
                      color: food.isVeg ? Colors.green : Colors.red,
                    ),
                  ),
                  const Divider(height: 26),
                  DetailRow(
                    icon: Icons.inventory_2_outlined,
                    title: 'Availability',
                    valueWidget: _Pill(
                      text: food.isAvailable ? 'Available' : 'Unavailable',
                      color: food.isAvailable ? Colors.blue : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const SectionTitle(
              title: 'Nutrition Information',
              caption: 'Per serving.',
            ),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.65,
              children: [
                NutritionInfoCard(
                  title: 'Calories',
                  value: '${_num(food.calories)} kcal',
                  icon: Icons.local_fire_department_rounded,
                ),
                NutritionInfoCard(
                  title: 'Protein',
                  value: '${_num(food.protein)} g',
                  icon: Icons.fitness_center_rounded,
                ),
                NutritionInfoCard(
                  title: 'Carbs',
                  value: '${_num(food.carbs)} g',
                  icon: Icons.bakery_dining_rounded,
                ),
                NutritionInfoCard(
                  title: 'Fat',
                  value: '${_num(food.fat)} g',
                  icon: Icons.water_drop_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;

  const _Pill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
