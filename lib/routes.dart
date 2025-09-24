import 'package:flutter/material.dart';
import 'package:ghanta_gadi/modules/auth/signup.dart';
import 'package:ghanta_gadi/modules/citizen/citizen_home.dart';
import 'package:ghanta_gadi/modules/driver/driver_home.dart';

import 'modules/auth/login.dart';

class AppRouter {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String citizenHome = '/citizen_home';
  static const String driverHome = '/driver_home';
  static const String driver = '/driver';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case citizenHome:
        return MaterialPageRoute(builder: (_) => const CitizenHome());
      case driverHome:
        return MaterialPageRoute(builder: (_) => const DriverHome());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
