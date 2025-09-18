import 'package:flutter/material.dart';
import 'package:ghanta_gadi/modules/auth/signup.dart';

import 'modules/auth/login.dart';

class AppRouter {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String driver = '/driver';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      // case dashboard:
      //   return MaterialPageRoute(builder: (_) => const DashboardScreen());
      // case driver:
      //   return MaterialPageRoute(builder: (_) => const DriverScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
