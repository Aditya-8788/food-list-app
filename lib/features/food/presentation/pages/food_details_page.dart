import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../orders/presentation/bloc/cart_cubit.dart';
import '../../../orders/presentation/widgets/cart_widgets.dart';
import '../../domain/entities/food_entity.dart';
import '../widgets/food_image.dart';
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
      appBar: AppBar(
        title: const Text('Food Details'),
        centerTitle: true,
        actions: [
          if (customerUid != null) CartIconButton(customerId: customerUid!),
          const SizedBox(width: 8),
        ],
      ),
      bottomNavigationBar: canOrder
          ? _AddToCartBar(food: food, customerId: customerUid!)
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (FoodImage.hasImage(food.imageUrl)) ...[
              FoodImage(
                url: food.imageUrl,
                width: double.infinity,
                height: 210,
                radius: 22,
                iconSize: 60,
              ),
              const SizedBox(height: 16),
            ],
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

/// "Add to cart" button, or a quantity stepper + "View cart" once added.
class _AddToCartBar extends StatelessWidget {
  final FoodEntity food;
  final String customerId;

  const _AddToCartBar({required this.food, required this.customerId});

  @override
  Widget build(BuildContext context) {
    final quantity = context.select<CartCubit, int>(
      (cubit) => cubit.state.quantityOf(food.id),
    );
    final cart = context.read<CartCubit>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
        child: quantity == 0
            ? FilledButton.icon(
                onPressed: () => addToCart(context, food),
                icon: const Icon(Icons.add_shopping_cart_rounded),
                label: Text('Add to cart · ${Helpers.currency(food.price)}'),
              )
            : Row(
                children: [
                  QuantityStepper(
                    value: quantity,
                    onDecrement: () => cart.remove(food),
                    onIncrement: quantity < CartCubit.maxQuantity
                        ? () => cart.add(food)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => openCart(context, customerId),
                      icon: const Icon(Icons.shopping_bag_rounded),
                      label: const Text('View cart'),
                    ),
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
