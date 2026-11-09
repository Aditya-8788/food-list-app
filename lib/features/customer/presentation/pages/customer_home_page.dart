import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_widgets.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../food/presentation/pages/food_list_page.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/presentation/bloc/cart_cubit.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';
import '../../../orders/presentation/bloc/order_event.dart';
import '../../../orders/presentation/bloc/order_state.dart';
import '../../../orders/presentation/pages/order_tracking_page.dart';
import '../../../orders/presentation/pages/orders_page.dart';
import '../../../orders/presentation/widgets/cart_widgets.dart';
import '../../../orders/presentation/widgets/order_card.dart';
import 'customer_profile_page.dart';

class CustomerHomePage extends StatelessWidget {
  final String uid;

  const CustomerHomePage({super.key, required this.uid});

  void _logout(BuildContext context) {
    context.read<CartCubit>().clear();
    context.read<AuthBloc>().add(AuthLogoutRequested());
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrderBloc>()..add(WatchCustomerOrdersRequested(uid)),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 18,
          title: const AppBarTitle(
            title: 'Food Delivery',
            subtitle: 'Healthy food with nutrition info',
          ),
          actions: [
            CartIconButton(customerId: uid),
            IconButton(
              tooltip: 'Profile',
              icon: const Icon(Icons.person_outline_rounded),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CustomerProfilePage(uid: uid),
                ),
              ),
            ),
            IconButton(
              tooltip: 'Logout',
              icon: const Icon(Icons.logout_rounded),
              onPressed: () => _logout(context),
            ),
            const SizedBox(width: 8),
          ],
        ),
        bottomNavigationBar: ViewCartBar(customerId: uid),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
          children: [
            const GradientHeader(
              label: 'Hungry?',
              title: 'What would you like to eat today?',
              footer: HeaderInfoTile(
                icon: Icons.delivery_dining_rounded,
                text: 'Order now and track it live',
              ),
            ),
            const SizedBox(height: 25),
            const SectionTitle(title: 'Quick Actions'),
            ActionTile(
              icon: Icons.restaurant_menu_rounded,
              title: 'Browse Foods',
              subtitle: 'Explore dishes with nutrition info',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FoodListPage(customerUid: uid),
                ),
              ),
            ),
            ActionTile(
              icon: Icons.receipt_long_rounded,
              title: 'My Orders',
              subtitle: 'View history and track deliveries',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OrdersPage(userId: uid)),
              ),
            ),
            ActionTile(
              icon: Icons.person_outline_rounded,
              title: 'My Profile',
              subtitle: 'Update your name, phone and address',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CustomerProfilePage(uid: uid),
                ),
              ),
            ),
            const SizedBox(height: 11),
            const _ActiveOrders(),
          ],
        ),
      ),
    );
  }
}

/// Shows orders that are still on their way, updated live.
class _ActiveOrders extends StatelessWidget {
  const _ActiveOrders();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is! OrderLoaded) return const SizedBox.shrink();

        final active = state.orders
            .where((o) => OrderStatus.isActive(o.status))
            .toList();
        if (active.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              title: 'Active Orders',
              caption: 'Live status of your current orders.',
            ),
            for (final order in active.take(3))
              OrderCard(
                order: order,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderTrackingPage(
                      orderId: order.id,
                      initialOrder: order,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
