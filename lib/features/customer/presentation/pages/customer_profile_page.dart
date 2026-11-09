import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_widgets.dart';
import '../../../orders/presentation/pages/orders_page.dart';
import '../bloc/customer_bloc.dart';
import '../bloc/customer_event.dart';
import '../bloc/customer_state.dart';
import '../widgets/customer_info_card.dart';
import 'edit_customer_profile_page.dart';

class CustomerProfilePage extends StatefulWidget {
  final String uid;

  const CustomerProfilePage({super.key, required this.uid});

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<CustomerBloc>().add(GetCustomerProfileRequested(widget.uid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile'), centerTitle: true),
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state is CustomerError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          // Reload after returning from a successful edit.
          if (state is CustomerUpdated) _load();
        },
        builder: (context, state) {
          if (state is CustomerLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
              child: Column(
                children: [
                  CustomerInfoCard(customer: state.customer),
                  const SizedBox(height: 20),
                  ActionTile(
                    icon: Icons.receipt_long_rounded,
                    title: 'My Orders',
                    subtitle: 'View history and track deliveries',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrdersPage(userId: widget.uid),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EditCustomerProfilePage(customer: state.customer),
                      ),
                    ),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit Profile'),
                  ),
                ],
              ),
            );
          }

          if (state is CustomerError) {
            return MessageView(
              icon: Icons.person_off_outlined,
              title: 'Unable to load profile',
              message: state.message,
              buttonText: 'Retry',
              onButtonPressed: _load,
            );
          }

          return const LoadingView(message: 'Loading profile...');
        },
      ),
    );
  }
}
