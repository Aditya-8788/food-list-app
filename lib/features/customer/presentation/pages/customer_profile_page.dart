// TODO: Implement customer profile page.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/customer_bloc.dart';
import '../bloc/customer_event.dart';
import '../bloc/customer_state.dart';
import '../widgets/customer_info_card.dart';
import 'edit_customer_profile_page.dart';

class CustomerProfilePage extends StatefulWidget {
  final String uid;

  const CustomerProfilePage({
    super.key,
    required this.uid,
  });

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  @override
  void initState() {
    super.initState();

    context.read<CustomerBloc>().add(
          GetCustomerProfileRequested(widget.uid),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Profile'),
        backgroundColor: const Color(0xffFF6B6B),
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state is CustomerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is CustomerLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CustomerLoaded) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(20),
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
              child: Column(
                children: [
                  CustomerInfoCard(customer: state.customer),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditCustomerProfilePage(
                            customer: state.customer,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xffFF6B6B),
                    ),
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('No customer data found'),
          );
        },
      ),
    );
  }
}