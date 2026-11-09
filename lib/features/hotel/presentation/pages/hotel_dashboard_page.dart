import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../food/presentation/pages/manage_food_page.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';
import '../../../orders/presentation/bloc/order_event.dart';
import '../../../orders/presentation/bloc/order_state.dart';
import '../../../orders/presentation/pages/orders_page.dart';
import '../bloc/hotel_bloc.dart';
import '../bloc/hotel_event.dart';
import '../bloc/hotel_state.dart';
import 'edit_hotel_profile_page.dart';
import 'hotel_profile_page.dart';

class HotelDashboardPage extends StatefulWidget {
  final String ownerId;
  final String ownerEmail;
  final String ownerName;

  const HotelDashboardPage({
    super.key,
    required this.ownerId,
    required this.ownerEmail,
    required this.ownerName,
  });

  @override
  State<HotelDashboardPage> createState() => _HotelDashboardPageState();
}

class _HotelDashboardPageState extends State<HotelDashboardPage> {
  @override
  void initState() {
    super.initState();
    refreshHotel();
  }

  void refreshHotel() {
    context.read<HotelBloc>().add(GetHotelProfileRequested(widget.ownerId));
  }

  void _logout() {
    context.read<AuthBloc>().add(AuthLogoutRequested());
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<OrderBloc>()..add(WatchHotelOrdersRequested(widget.ownerId)),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 18,
          title: const AppBarTitle(
            title: 'Hotel Dashboard',
            subtitle: 'Manage menu and customer orders',
          ),
          actions: [
            IconButton(
              tooltip: 'Hotel profile',
              icon: const Icon(Icons.storefront_outlined),
              onPressed: () {
                final state = context.read<HotelBloc>().state;
                if (state is HotelLoaded) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HotelProfilePage(hotel: state.hotel),
                    ),
                  );
                }
              },
            ),
            IconButton(
              tooltip: 'Logout',
              icon: const Icon(Icons.logout_rounded),
              onPressed: _logout,
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: BlocConsumer<HotelBloc, HotelState>(
          listener: (context, state) {
            if (state is HotelError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is HotelActionSuccess) refreshHotel();
          },
          builder: (context, state) {
            if (state is HotelLoading || state is HotelInitial) {
              return const LoadingView(message: 'Loading dashboard...');
            }

            if (state is HotelNotCreated) {
              return MessageView(
                icon: Icons.storefront_outlined,
                title: 'Set up your restaurant',
                message:
                    'Create your hotel profile to start adding food and receiving orders.',
                buttonText: 'Create Hotel Profile',
                buttonIcon: Icons.add_business_rounded,
                onButtonPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditHotelProfilePage(
                        ownerId: widget.ownerId,
                        ownerEmail: widget.ownerEmail,
                        ownerName: widget.ownerName,
                      ),
                    ),
                  );
                  refreshHotel();
                },
              );
            }

            if (state is HotelError) {
              return MessageView(
                icon: Icons.cloud_off_rounded,
                title: 'Unable to load dashboard',
                message: state.message,
                buttonText: 'Retry',
                onButtonPressed: refreshHotel,
              );
            }

            if (state is! HotelLoaded) return const SizedBox.shrink();
            final hotel = state.hotel;

            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
              children: [
                GradientHeader(
                  label: 'Welcome back',
                  title: hotel.hotelName,
                  footer: HeaderInfoTile(
                    icon: hotel.isOpen
                        ? Icons.check_circle_outline_rounded
                        : Icons.do_not_disturb_on_outlined,
                    text: hotel.isOpen ? 'Open for orders' : 'Currently closed',
                  ),
                ),
                const SizedBox(height: 20),
                const _OrderOverview(),
                const SizedBox(height: 25),
                const SectionTitle(title: 'Manage'),
                ActionTile(
                  icon: Icons.receipt_long_rounded,
                  title: 'Orders',
                  subtitle: 'Accept, prepare and deliver orders',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          OrdersPage(userId: widget.ownerId, isHotel: true),
                    ),
                  ),
                ),
                ActionTile(
                  icon: Icons.restaurant_menu_rounded,
                  title: 'Manage Food',
                  subtitle: 'Add, edit and delete food items',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ManageFoodPage(
                        ownerId: widget.ownerId,
                        hotelId: hotel.hotelId,
                      ),
                    ),
                  ),
                ),
                ActionTile(
                  icon: Icons.storefront_rounded,
                  title: 'Hotel Profile',
                  subtitle: 'View and update hotel details',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HotelProfilePage(hotel: hotel),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OrderOverview extends StatelessWidget {
  const _OrderOverview();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        final orders = state is OrderLoaded
            ? state.orders
            : const <OrderEntity>[];
        final newOrders = orders
            .where((o) => o.status == OrderStatus.placed)
            .length;
        final active = orders
            .where((o) => OrderStatus.isActive(o.status))
            .length;
        final delivered = orders
            .where((o) => o.status == OrderStatus.delivered)
            .toList();
        final revenue = delivered.fold<double>(
          0,
          (sum, o) => sum + o.totalAmount,
        );

        return Column(
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
                  title: 'New Orders',
                  value: '$newOrders',
                  icon: Icons.notifications_active_rounded,
                ),
                SummaryCard(
                  title: 'In Progress',
                  value: '$active',
                  icon: Icons.soup_kitchen_rounded,
                ),
                SummaryCard(
                  title: 'Delivered',
                  value: '${delivered.length}',
                  icon: Icons.verified_rounded,
                ),
                SummaryCard(
                  title: 'Revenue',
                  value: Helpers.currency(revenue),
                  icon: Icons.currency_rupee_rounded,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
