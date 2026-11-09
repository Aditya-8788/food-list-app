import 'package:flutter/material.dart';

import '../../domain/entities/order_entity.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = colorFor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  static Color colorFor(String status) {
    switch (status) {
      case OrderStatus.placed:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.purple;
      case OrderStatus.preparing:
        return Colors.amber.shade800;
      case OrderStatus.outForDelivery:
        return Colors.blue;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static IconData iconFor(String status) {
    switch (status) {
      case OrderStatus.placed:
        return Icons.receipt_long_rounded;
      case OrderStatus.confirmed:
        return Icons.verified_rounded;
      case OrderStatus.preparing:
        return Icons.soup_kitchen_rounded;
      case OrderStatus.outForDelivery:
        return Icons.delivery_dining_rounded;
      case OrderStatus.delivered:
        return Icons.home_rounded;
      case OrderStatus.cancelled:
        return Icons.cancel_rounded;
      default:
        return Icons.circle_outlined;
    }
  }
}
