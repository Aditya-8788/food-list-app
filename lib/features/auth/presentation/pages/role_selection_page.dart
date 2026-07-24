// TODO: Implement role selection page.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_entity.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RoleSelectionPage extends StatelessWidget {
  final UserEntity user;

  const RoleSelectionPage({
    super.key,
    required this.user,
  });

  void saveRole(BuildContext context, String role) {
    context.read<AuthBloc>().add(
          AuthSaveRoleRequested(
            uid: user.uid,
            role: role,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => state.user.role == 'customer'
                    ? const CustomerTempPage()
                    : const HotelTempPage(),
              ),
            );
          }

          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(24),
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
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Choose Your Role',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Customer'),
                      subtitle: const Text('Order food'),
                      onTap: () => saveRole(context, 'customer'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.restaurant),
                      title: const Text('Hotel Owner'),
                      subtitle: const Text('Add food and manage orders'),
                      onTap: () => saveRole(context, 'hotel'),
                    ),
                    if (state is AuthLoading) ...[
                      const SizedBox(height: 20),
                      const CircularProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomerTempPage extends StatelessWidget {
  const CustomerTempPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Customer Home Page')),
    );
  }
}

class HotelTempPage extends StatelessWidget {
  const HotelTempPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Hotel Dashboard Page')),
    );
  }
}