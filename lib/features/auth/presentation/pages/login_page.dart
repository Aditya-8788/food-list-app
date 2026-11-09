import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_widgets.dart';
import '../widgets/auth_scaffold.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'package:fooddelivery/features/customer/presentation/pages/customer_home_page.dart';
import 'package:fooddelivery/features/hotel/presentation/pages/hotel_dashboard_page.dart';
import 'role_selection_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    context.read<AuthBloc>().add(
      AuthLoginRequested(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ),
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
    } else {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          navigateByRole(state);
        }

        if (state is AuthRoleRequired) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => RoleSelectionPage(user: state.user),
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
          title: 'Welcome back',
          subtitle: 'Log in to order food and track it live',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormFieldBox(
                controller: emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              FormFieldBox(
                controller: passwordController,
                label: 'Password',
                icon: Icons.lock_outline_rounded,
                obscureText: !isPasswordVisible,
                suffix: IconButton(
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() => isPasswordVisible = !isPasswordVisible);
                  },
                ),
              ),
              const SizedBox(height: 10),
              state is AuthLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: login,
                      child: const Text('Login'),
                    ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupPage()),
                  );
                },
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        );
      },
    );
  }
}
