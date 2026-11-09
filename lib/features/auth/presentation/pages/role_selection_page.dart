import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_widgets.dart';
import '../../../customer/presentation/pages/customer_home_page.dart';
import '../../../hotel/presentation/pages/hotel_dashboard_page.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_scaffold.dart';

class RoleSelectionPage extends StatelessWidget {
  final UserEntity user;

  const RoleSelectionPage({super.key, required this.user});

  void saveRole(BuildContext context, String role) {
    context.read<AuthBloc>().add(
      AuthSaveRoleRequested(uid: user.uid, role: role),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          final authUser = state.user;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => authUser.role == 'customer'
                  ? CustomerHomePage(uid: authUser.uid)
                  : HotelDashboardPage(
                      ownerId: authUser.uid,
                      ownerEmail: authUser.email,
                      ownerName: authUser.name,
                    ),
            ),
          );
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return AuthScaffold(
          title: 'Choose Your Role',
          subtitle: 'How will you use the app?',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ActionTile(
                icon: Icons.person_outline_rounded,
                title: 'Customer',
                subtitle: 'Order food and track deliveries',
                onTap: () => saveRole(context, 'customer'),
              ),
              ActionTile(
                icon: Icons.storefront_outlined,
                title: 'Hotel Owner',
                subtitle: 'Add food and manage orders',
                onTap: () => saveRole(context, 'hotel'),
              ),
              if (state is AuthLoading) ...[
                const SizedBox(height: 8),
                const CircularProgressIndicator(),
              ],
            ],
          ),
        );
      },
    );
  }
}
