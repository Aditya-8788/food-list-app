import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/order_entity.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import '../widgets/order_card.dart';
import 'order_tracking_page.dart';

enum OrderSortOption { newest, oldest, amountHighToLow, amountLowToHigh }

/// Live list of orders for a customer ("My Orders") or a hotel owner.
class OrdersPage extends StatelessWidget {
  final String userId;
  final bool isHotel;

  const OrdersPage({super.key, required this.userId, this.isHotel = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrderBloc>()
        ..add(
          isHotel
              ? WatchHotelOrdersRequested(userId)
              : WatchCustomerOrdersRequested(userId),
        ),
      child: _OrdersView(isHotel: isHotel),
    );
  }
}

class _OrdersView extends StatefulWidget {
  final bool isHotel;

  const _OrdersView({required this.isHotel});

  @override
  State<_OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<_OrdersView> {
  final _searchController = TextEditingController();
  OrderSortOption _sort = OrderSortOption.newest;
  String _query = '';
  String _status = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<OrderEntity> _visible(List<OrderEntity> orders) {
    final q = _query.trim().toLowerCase();
    final filtered = orders.where((order) {
      final matchesSearch =
          q.isEmpty ||
          order.id.toLowerCase().contains(q) ||
          order.customerName.toLowerCase().contains(q) ||
          order.hotelName.toLowerCase().contains(q) ||
          order.items.any((i) => i.name.toLowerCase().contains(q));
      final matchesStatus =
          _status == 'All' ||
          (_status == 'Active' && OrderStatus.isActive(order.status)) ||
          order.status == _status;
      return matchesSearch && matchesStatus;
    }).toList();

    switch (_sort) {
      case OrderSortOption.newest:
        filtered.sort((a, b) => b.placedAt.compareTo(a.placedAt));
      case OrderSortOption.oldest:
        filtered.sort((a, b) => a.placedAt.compareTo(b.placedAt));
      case OrderSortOption.amountHighToLow:
        filtered.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
      case OrderSortOption.amountLowToHigh:
        filtered.sort((a, b) => a.totalAmount.compareTo(b.totalAmount));
    }
    return filtered;
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _status = 'All';
      _sort = OrderSortOption.newest;
    });
  }

  void _open(OrderEntity order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderTrackingPage(
          orderId: order.id,
          initialOrder: order,
          isHotel: widget.isHotel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 18,
        title: AppBarTitle(
          title: widget.isHotel ? 'Incoming Orders' : 'My Orders',
          subtitle: widget.isHotel
              ? 'Manage and update customer orders'
              : 'Track your food orders live',
        ),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderInitial || state is OrderLoading) {
            return const LoadingView(message: 'Loading orders...');
          }

          if (state is OrderError) {
            return MessageView(
              icon: Icons.cloud_off_rounded,
              title: 'Unable to load orders',
              message: state.message,
            );
          }

          if (state is OrderEmpty) {
            return MessageView(
              icon: Icons.shopping_bag_outlined,
              title: 'No orders yet',
              message: widget.isHotel
                  ? 'New orders from customers will appear here instantly.'
                  : 'Order something tasty and track it here in real time.',
            );
          }

          final orders = (state as OrderLoaded).orders;
          final visible = _visible(orders);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _SummarySection(orders: orders, isHotel: widget.isHotel),
              ),
              SliverToBoxAdapter(
                child: _FilterSection(
                  controller: _searchController,
                  query: _query,
                  status: _status,
                  sort: _sort,
                  resultCount: visible.length,
                  onQueryChanged: (v) => setState(() => _query = v),
                  onStatusChanged: (v) => setState(() => _status = v),
                  onSortChanged: (v) => setState(() => _sort = v),
                  onClear: _clearFilters,
                ),
              ),
              if (visible.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: MessageView(
                    icon: Icons.search_off_rounded,
                    title: 'No matching orders',
                    message: 'Try another order ID, name, food or status.',
                    buttonText: 'Clear filters',
                    buttonIcon: Icons.filter_alt_off_rounded,
                    onButtonPressed: _clearFilters,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
                  sliver: SliverList.builder(
                    itemCount: visible.length,
                    itemBuilder: (context, index) {
                      final order = visible[index];
                      return TweenAnimationBuilder<double>(
                        key: ValueKey(order.id),
                        duration: Duration(milliseconds: 250 + index * 60),
                        tween: Tween(begin: 0, end: 1),
                        builder: (context, value, child) => Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 18 * (1 - value)),
                            child: child,
                          ),
                        ),
                        child: OrderCard(
                          order: order,
                          showCustomer: widget.isHotel,
                          onTap: () => _open(order),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  final List<OrderEntity> orders;
  final bool isHotel;

  const _SummarySection({required this.orders, required this.isHotel});

  @override
  Widget build(BuildContext context) {
    final active = orders.where((o) => OrderStatus.isActive(o.status)).length;
    final delivered = orders
        .where((o) => o.status == OrderStatus.delivered)
        .toList();
    final amount =
        (isHotel
                ? delivered
                : orders.where((o) => o.status != OrderStatus.cancelled))
            .fold<double>(0, (sum, o) => sum + o.totalAmount);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.65,
            children: [
              SummaryCard(
                title: 'Total Orders',
                value: '${orders.length}',
                icon: Icons.shopping_bag_rounded,
              ),
              SummaryCard(
                title: 'Active',
                value: '$active',
                icon: Icons.delivery_dining_rounded,
              ),
              SummaryCard(
                title: 'Delivered',
                value: '${delivered.length}',
                icon: Icons.verified_rounded,
              ),
              SummaryCard(
                title: isHotel ? 'Revenue' : 'Total Spent',
                value: Helpers.currency(amount),
                icon: Icons.currency_rupee_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final String status;
  final OrderSortOption sort;
  final int resultCount;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<OrderSortOption> onSortChanged;
  final VoidCallback onClear;

  const _FilterSection({
    required this.controller,
    required this.query,
    required this.status,
    required this.sort,
    required this.resultCount,
    required this.onQueryChanged,
    required this.onStatusChanged,
    required this.onSortChanged,
    required this.onClear,
  });

  static const _statuses = [
    'All',
    'Active',
    ...OrderStatus.flow,
    OrderStatus.cancelled,
  ];

  @override
  Widget build(BuildContext context) {
    final hasFilters = query.isNotEmpty || status != 'All';

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            onChanged: onQueryChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search by order ID, name or food',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: query.isNotEmpty
                  ? IconButton(
                      tooltip: 'Clear search',
                      onPressed: () {
                        controller.clear();
                        onQueryChanged('');
                      },
                      icon: const Icon(Icons.close_rounded),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _statuses.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final s = _statuses[index];
                return FilterChip(
                  label: Text(s),
                  selected: status == s,
                  showCheckmark: false,
                  onSelected: (_) => onStatusChanged(s),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.sort_rounded, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Sort by',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<OrderSortOption>(
                  initialValue: sort,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: OrderSortOption.newest,
                      child: Text('Newest first'),
                    ),
                    DropdownMenuItem(
                      value: OrderSortOption.oldest,
                      child: Text('Oldest first'),
                    ),
                    DropdownMenuItem(
                      value: OrderSortOption.amountHighToLow,
                      child: Text('Amount: high to low'),
                    ),
                    DropdownMenuItem(
                      value: OrderSortOption.amountLowToHigh,
                      child: Text('Amount: low to high'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) onSortChanged(v);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '$resultCount ${resultCount == 1 ? 'order' : 'orders'} found',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (hasFilters)
                TextButton.icon(
                  onPressed: onClear,
                  icon: const Icon(Icons.filter_alt_off_rounded, size: 18),
                  label: const Text('Clear filters'),
                )
              else
                const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
