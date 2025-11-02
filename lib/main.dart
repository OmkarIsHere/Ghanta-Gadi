import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ghanta_gadi/core/constant/sf_constant.dart';
import 'package:ghanta_gadi/data/services/notification_service.dart' show NotificationService;
import 'package:ghanta_gadi/modules/admin/admin_home.dart';
import 'package:ghanta_gadi/providers/auth_provider.dart';
import 'package:ghanta_gadi/providers/map_provider.dart';
import 'package:ghanta_gadi/providers/permission_provider.dart';
import 'package:ghanta_gadi/providers/user_provider.dart';
import 'package:ghanta_gadi/providers/vehicle_provider.dart';
import 'package:ghanta_gadi/routes.dart';
import 'package:provider/provider.dart' show MultiProvider, ChangeNotifierProvider;

import 'core/config/theme.dart';
import 'core/helper/sf_helper.dart';
import 'modules/auth/login.dart';
import 'modules/citizen/citizen_home.dart';
import 'modules/driver/driver_home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  await SFHelper.init();

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => PermissionProvider()),
            ChangeNotifierProvider(create: (_) => MapProvider()),
            ChangeNotifierProvider(create: (_) => UserProvider()),
            ChangeNotifierProvider(create: (_) => VehicleProvider()),
          ],
          child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String?> _getRole() async {
    return await SFHelper.get(SfConstant.uRole);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ghanta Gadi',
      debugShowCheckedModeBanner: false,
      theme: MyTheme().lightTheme,
      onGenerateRoute: AppRouter.generateRoute,
      home: FutureBuilder<String?>(
        future: _getRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('Something went wrong')),
            );
          }

          final role = snapshot.data;
          if (role == null) {
            return const LoginScreen();
          } else if (role == 'citizen') {
            return const CitizenHome();
          } else if (role == 'driver') {
            return const DriverHome();
          } else {
            return const AdminHome();
          }
        },
      ),
    );
  }
}
