// TODO: Implement hotel dashboard page.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../food/presentation/pages/manage_food_page.dart';
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

    context.read<HotelBloc>().add(
          GetHotelProfileRequested(widget.ownerId),
        );
  }

  void refreshHotel() {
    context.read<HotelBloc>().add(
          GetHotelProfileRequested(widget.ownerId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Dashboard'),
        backgroundColor: const Color(0xffFF6B6B),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
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
        ],
      ),
      body: BlocConsumer<HotelBloc, HotelState>(
        listener: (context, state) {
          if (state is HotelError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is HotelLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HotelNotCreated) {
            return _dashboardBackground(
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xffFF6B6B),
                    minimumSize: const Size(240, 55),
                  ),
                  child: const Text('Create Hotel Profile'),
                ),
              ),
            );
          }

          if (state is HotelLoaded) {
            return _dashboardBackground(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _dashboardCard(
                      icon: Icons.restaurant_menu,
                      title: 'Manage Food',
                      subtitle: 'Add, edit and delete food items',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ManageFoodPage(
                              ownerId: widget.ownerId,
                              hotelId: state.hotel.hotelId,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _dashboardCard(
                      icon: Icons.store,
                      title: 'Hotel Profile',
                      subtitle: 'View and update hotel details',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HotelProfilePage(
                              hotel: state.hotel,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _dashboardCard(
                      icon: Icons.receipt_long,
                      title: 'Orders',
                      subtitle: 'Orders feature will be added later',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _dashboardBackground({required Widget child}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xffFF6B6B),
            Color(0xffFF8E53),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }

  Widget _dashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(18),
        leading: CircleAvatar(
          backgroundColor: const Color(0xffFF6B6B),
          foregroundColor: Colors.white,
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}