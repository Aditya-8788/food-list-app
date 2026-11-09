import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/order_usecases.dart';
import '../bloc/order_action_cubit.dart';
import '../widgets/order_timeline.dart';
import '../widgets/status_chip.dart';

/// Live order details + tracking timeline.
///
/// Customers can watch progress and cancel while the order is still "Placed".
/// Hotel owners can move the order to its next status.
class OrderTrackingPage extends StatefulWidget {
  final String orderId;
  final OrderEntity? initialOrder;
  final bool isHotel;

  const OrderTrackingPage({
    super.key,
    required this.orderId,
    this.initialOrder,
    this.isHotel = false,
  });

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  late final Stream<OrderEntity?> _orderStream = sl<WatchOrderUseCase>()(
    widget.orderId,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrderActionCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Track Order'), centerTitle: true),
        body: BlocListener<OrderActionCubit, OrderActionState>(
          listener: (context, state) {
            if (state is OrderActionSuccess || state is OrderActionFailure) {
              final message = state is OrderActionSuccess
                  ? state.message
                  : (state as OrderActionFailure).message;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(message)));
            }
          },
          child: StreamBuilder<OrderEntity?>(
            stream: _orderStream,
            initialData: widget.initialOrder,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return MessageView(
                  icon: Icons.cloud_off_rounded,
                  title: 'Unable to load order',
                  message: snapshot.error.toString(),
                );
              }

              final order = snapshot.data;
              if (order == null) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingView(message: 'Loading order...');
                }
                return const MessageView(
                  icon: Icons.receipt_long_outlined,
                  title: 'Order not found',
                  message: 'This order may have been removed.',
                );
              }

              return _OrderDetails(order: order, isHotel: widget.isHotel);
            },
          ),
        ),
      ),
    );
  }
}

class _OrderDetails extends StatelessWidget {
  final OrderEntity order;
  final bool isHotel;

  const _OrderDetails({required this.order, required this.isHotel});

  @override
  Widget build(BuildContext context) {
    final step = OrderStatus.flow.indexOf(order.status);
    final progress = step < 0 ? 0.0 : (step + 1) / OrderStatus.flow.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientHeader(
            label: 'Order number',
            title: '#${order.shortId}',
            trailing: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                StatusChip.iconFor(order.status),
                color: Colors.white,
              ),
            ),
            footer: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.status == OrderStatus.cancelled
                      ? 'Order cancelled'
                      : order.status == OrderStatus.delivered
                      ? 'Delivered — enjoy your meal!'
                      : 'Status: ${order.status}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: progress),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value,
                      minHeight: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                HeaderInfoTile(
                  icon: isHotel
                      ? Icons.person_outline_rounded
                      : Icons.storefront_outlined,
                  text: isHotel ? order.customerName : order.hotelName,
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const SectionTitle(
            title: 'Order Timeline',
            caption: 'Updates appear here in real time.',
          ),
          SectionCard(child: OrderTimeline(order: order)),
          const SizedBox(height: 25),
          if (isHotel) ...[
            _HotelActions(order: order),
            const SizedBox(height: 25),
          ],
          const SectionTitle(title: 'Order Details'),
          SectionCard(
            child: Column(
              children: [
                DetailRow(
                  icon: Icons.calendar_month_outlined,
                  title: 'Placed on',
                  value: Helpers.dateTime(order.placedAt),
                ),
                const Divider(height: 26),
                DetailRow(
                  icon: Icons.local_shipping_outlined,
                  title: 'Current status',
                  valueWidget: Align(
                    alignment: Alignment.centerLeft,
                    child: StatusChip(status: order.status),
                  ),
                ),
                const Divider(height: 26),
                DetailRow(
                  icon: Icons.location_on_outlined,
                  title: 'Delivery address',
                  value: order.deliveryAddress.isEmpty
                      ? 'Not provided'
                      : order.deliveryAddress,
                ),
                if (order.customerPhone.isNotEmpty) ...[
                  const Divider(height: 26),
                  DetailRow(
                    icon: Icons.phone_outlined,
                    title: 'Contact',
                    value: order.customerPhone,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 25),
          const SectionTitle(title: 'Bill Summary'),
          SectionCard(
            child: Column(
              children: [
                for (final item in order.items) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: item.isVeg ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${item.name} × ${item.quantity}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(Helpers.currency(item.total)),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                const Divider(height: 14),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      Helpers.currency(order.totalAmount),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!isHotel && order.status == OrderStatus.placed) ...[
            const SizedBox(height: 25),
            _CancelButton(order: order),
          ],
        ],
      ),
    );
  }
}

class _HotelActions extends StatelessWidget {
  final OrderEntity order;

  const _HotelActions({required this.order});

  @override
  Widget build(BuildContext context) {
    final next = OrderStatus.next(order.status);
    if (next == null || order.status == OrderStatus.cancelled) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<OrderActionCubit, OrderActionState>(
      builder: (context, state) {
        final busy = state is OrderActionInProgress;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: busy
                  ? null
                  : () => context.read<OrderActionCubit>().updateStatus(
                      order.id,
                      next,
                    ),
              icon: busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(StatusChip.iconFor(next)),
              label: Text('Mark as $next'),
            ),
            if (order.status == OrderStatus.placed) ...[
              const SizedBox(height: 10),
              _CancelButton(order: order, label: 'Reject order'),
            ],
          ],
        );
      },
    );
  }
}

class _CancelButton extends StatelessWidget {
  final OrderEntity order;
  final String label;

  const _CancelButton({required this.order, this.label = 'Cancel order'});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: BorderSide(color: Colors.red.shade200),
        ),
        onPressed: () async {
          final cubit = context.read<OrderActionCubit>();
          final confirmed =
              await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text(label),
                  content: const Text('Are you sure? This cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: const Text('Keep order'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: Text(
                        label,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ) ??
              false;
          if (confirmed) {
            cubit.updateStatus(order.id, OrderStatus.cancelled);
          }
        },
        icon: const Icon(Icons.cancel_outlined),
        label: Text(label),
      ),
    );
  }
}
