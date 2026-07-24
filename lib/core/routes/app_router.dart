import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/customer/presentation/pages/customer_home_page.dart';
import '../../features/food/presentation/pages/food_list_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

class AppRouter {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const customerHome = '/customer-home';
  static const foods = '/foods';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());

      case foods:
        return MaterialPageRoute(builder: (_) => const FoodListPage());

      case customerHome:
        final uid = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CustomerHomePage(uid: uid),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route Not Found')),
          ),
        );
    }
  }
}