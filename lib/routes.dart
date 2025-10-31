import 'package:flutter/material.dart';
import 'package:ghanta_gadi/modules/permission/permission_view.dart';
import 'package:ghanta_gadi/modules/vehicle/add_vehicle.dart';
import 'package:ghanta_gadi/modules/admin/admin_home.dart';
import 'package:ghanta_gadi/modules/auth/create_user.dart';
import 'package:ghanta_gadi/modules/citizen/citizen_home.dart';
import 'package:ghanta_gadi/modules/driver/driver_home.dart';

import 'core/widgets/route_error.dart';
import 'modules/auth/login.dart';
import 'modules/feedback/add_feedback.dart';

class AppRouter {
  static const String permission = '/permission';
  static const String login = '/login';
  static const String createUser = '/create_user';
  static const String citizenHome = '/citizen_home';
  static const String driverHome = '/driver_home';
  static const String adminHome = '/admin_home';
  static const String addVehicle = '/add_vehicle';
  static const String addFeedback = '/add_feedback';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case permission:
        return MaterialPageRoute(builder: (_) => const PermissionView());
      case createUser:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CreateUser(
            name: args?['name'],
          ),
        );
      case citizenHome:
        return MaterialPageRoute(builder: (_) => const CitizenHome());
      case driverHome:
        return MaterialPageRoute(builder: (_) => const DriverHome());
      case adminHome:
        return MaterialPageRoute(builder: (_) => const AdminHome());
      case addVehicle:
        return MaterialPageRoute(builder: (_) => const AddVehicle());
      case addFeedback:
        return MaterialPageRoute(builder: (_) => const AddFeedback());
      default:
        return MaterialPageRoute(builder: (_) => const RouteError());
    }
  }
}
