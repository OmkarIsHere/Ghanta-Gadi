import 'package:flutter/material.dart';
import 'package:ghanta_gadi/modules/admin/admin_home.dart';
import 'package:ghanta_gadi/modules/auth/signup.dart';
import 'package:ghanta_gadi/modules/citizen/citizen_home.dart';
import 'package:ghanta_gadi/modules/driver/driver_home.dart';

import 'core/widgets/route_error.dart';
import 'modules/auth/login.dart';

class AppRouter {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String citizenHome = '/citizen_home';
  static const String driverHome = '/driver_home';
  static const String adminHome = '/admin_home';

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
      case adminHome:
        return MaterialPageRoute(builder: (_) => const AdminHome());
      default:
        return MaterialPageRoute(builder: (_) => const RouteError());
    }
  }
}
