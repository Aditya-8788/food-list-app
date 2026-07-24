import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fooddelivery/core/constants/app_colors.dart';
import 'package:fooddelivery/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fooddelivery/features/auth/presentation/bloc/auth_event.dart';
import 'package:fooddelivery/features/auth/presentation/bloc/auth_state.dart';
import 'package:fooddelivery/features/auth/presentation/pages/login_page.dart';
import 'package:fooddelivery/features/auth/presentation/pages/role_selection_page.dart';
import 'package:fooddelivery/features/customer/presentation/pages/customer_home_page.dart';
import 'package:fooddelivery/features/hotel/presentation/pages/hotel_dashboard_page.dart';
import 'package:fooddelivery/features/splash/presentation/widgets/animated_logo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.read<AuthBloc>().add(AuthCheckRequested());
      }
    });
  }

  void navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void navigateByRole(AuthAuthenticated state) {
    if (state.user.role == 'customer') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CustomerHomePage(uid: state.user.uid),
        ),
      );
    } else if (state.user.role == 'hotel') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HotelDashboardPage(
            ownerId: state.user.uid,
            ownerEmail: state.user.email,
            ownerName: state.user.name,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RoleSelectionPage(user: state.user),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            navigateToLogin();
          } else if (state is AuthAuthenticated) {
            navigateByRole(state);
          } else if (state is AuthRoleRequired) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => RoleSelectionPage(user: state.user),
              ),
            );
          } else if (state is AuthError) {
            navigateToLogin();
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppColors.gradient,
          ),
          child: const Center(
            child: AnimatedLogo(),
          ),
        ),
      ),
    );
  }
}