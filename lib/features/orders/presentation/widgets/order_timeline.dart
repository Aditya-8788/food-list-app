import 'package:flutter/material.dart';

import '../../../../core/utils/helpers.dart';
import '../../domain/entities/order_entity.dart';

/// Vertical step tracker: Placed → Confirmed → Preparing → Out for Delivery → Delivered.
class OrderTimeline extends StatelessWidget {
  final OrderEntity order;

  const OrderTimeline({super.key, required this.order});

  static const _descriptions = {
    OrderStatus.placed: 'We have received your order.',
    OrderStatus.confirmed: 'The restaurant accepted your order.',
    OrderStatus.preparing: 'Your food is being prepared.',
    OrderStatus.outForDelivery: 'Your rider is on the way.',
    OrderStatus.delivered: 'Enjoy your meal!',
    OrderStatus.cancelled: 'This order was cancelled.',
  };

  @override
  Widget build(BuildContext context) {
    final isCancelled = order.status == OrderStatus.cancelled;

    // For a cancelled order, show the steps it reached and then "Cancelled".
    final steps = isCancelled
        ? [
            ...OrderStatus.flow.where((s) => order.timeOf(s) != null),
            OrderStatus.cancelled,
          ]
        : OrderStatus.flow;

    final currentIndex = steps.indexOf(order.status);

    return Column(
      children: List.generate(steps.length, (index) {
        final status = steps[index];
        return _TimelineStep(
          status: status,
          description: _descriptions[status] ?? '',
          time: order.timeOf(status),
          isCompleted: index <= currentIndex,
          isCurrent: index == currentIndex,
          isFirst: index == 0,
          isLast: index == steps.length - 1,
          lineDoneBelow: index < currentIndex,
          color: status == OrderStatus.cancelled
              ? Colors.red
              : Theme.of(context).colorScheme.primary,
        );
      }),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String status;
  final String description;
  final DateTime? time;
  final bool isCompleted;
  final bool isCurrent;
  final bool isFirst;
  final bool isLast;
  final bool lineDoneBelow;
  final Color color;

  const _TimelineStep({
    required this.status,
    required this.description,
    required this.time,
    required this.isCompleted,
    required this.isCurrent,
    required this.isFirst,
    required this.isLast,
    required this.lineDoneBelow,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final inactive = Colors.grey.shade300;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 3,
                    color: isFirst
                        ? Colors.transparent
                        : (isCompleted ? color : inactive),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? color : inactive,
                    border: isCurrent
                        ? Border.all(
                            color: color.withValues(alpha: 0.25),
                            width: 5,
                          )
                        : null,
                  ),
                  child: Icon(
                    status == OrderStatus.cancelled
                        ? Icons.close_rounded
                        : (isCompleted
                              ? Icons.check_rounded
                              : Icons.circle_outlined),
                    size: 16,
                    color: isCompleted ? Colors.white : Colors.grey,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 3,
                    color: isLast
                        ? Colors.transparent
                        : (lineDoneBelow ? color : inactive),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? color.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isCurrent
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: isCompleted
                                  ? Colors.black87
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ),
                        if (isCurrent)
                          Text(
                            'Current',
                            style: TextStyle(
                              color: color,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      time != null
                          ? '${Helpers.dateTime(time!)} · $description'
                          : description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isCompleted
                            ? Colors.grey.shade700
                            : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
