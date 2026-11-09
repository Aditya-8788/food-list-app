import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/helpers.dart';
import '../../../food/domain/entities/food_entity.dart';
import '../bloc/cart_cubit.dart';
import '../pages/checkout_page.dart';

void openCart(BuildContext context, String customerId) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => CheckoutPage(customerId: customerId)),
  );
}

/// Adds [food] to the cart, asking first if it would replace items
/// from another restaurant.
Future<void> addToCart(BuildContext context, FoodEntity food) async {
  final cart = context.read<CartCubit>();

  if (cart.conflictsWith(food)) {
    final replace =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Start a new cart?'),
            content: const Text(
              'Your cart has dishes from another restaurant. '
              'Adding this dish will remove them.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Keep cart'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Start new cart'),
              ),
            ],
          ),
        ) ??
        false;
    if (!replace) return;
  }

  cart.add(food);
}

/// App bar cart icon with an item-count badge.
class CartIconButton extends StatelessWidget {
  final String customerId;

  const CartIconButton({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    final count = context.select<CartCubit, int>((c) => c.state.itemCount);

    return IconButton(
      tooltip: 'Cart',
      onPressed: () => openCart(context, customerId),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: const Icon(Icons.shopping_bag_outlined),
      ),
    );
  }
}

/// − qty + control.
class QuantityStepper extends StatelessWidget {
  final int value;
  final VoidCallback onDecrement;
  final VoidCallback? onIncrement;

  const QuantityStepper({
    super.key,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: 'Remove one',
            onPressed: onDecrement,
            icon: Icon(
              value <= 1 ? Icons.delete_outline_rounded : Icons.remove_rounded,
              color: primary,
            ),
          ),
          Text('$value', style: const TextStyle(fontWeight: FontWeight.w800)),
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: 'Add one',
            onPressed: onIncrement,
            icon: Icon(Icons.add_rounded, color: primary),
          ),
        ],
      ),
    );
  }
}

/// Floating bottom bar shown while the cart has items.
class ViewCartBar extends StatelessWidget {
  final String customerId;

  const ViewCartBar({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cart) {
        if (cart.isEmpty) return const SizedBox.shrink();

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
            child: Material(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => openCart(context, customerId),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${cart.itemCount} '
                        '${cart.itemCount == 1 ? 'item' : 'items'} · '
                        '${Helpers.currency(cart.total)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'View cart',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
