import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ghanta_gadi/core/constant/sf_constant.dart';
import 'package:ghanta_gadi/modules/admin/admin_home.dart';
import 'package:ghanta_gadi/providers/auth_provider.dart';
import 'package:ghanta_gadi/providers/map_provider.dart';
import 'package:ghanta_gadi/providers/permission_provider.dart';
import 'package:ghanta_gadi/providers/user_provider.dart';
import 'package:ghanta_gadi/routes.dart';
import 'package:provider/provider.dart' show MultiProvider, ChangeNotifierProvider;

import 'core/config/theme.dart';
import 'core/helper/sf_helper.dart';
import 'modules/auth/login.dart';
import 'modules/citizen/citizen_home.dart';
import 'modules/driver/driver_home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    await dotenv.load(fileName: ".env");
    await SFHelper.init();
  }catch(e){
    print("ERROR: ${e.toString()}");
  }
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => PermissionProvider()),
            ChangeNotifierProvider(create: (_) => MapProvider()),
            ChangeNotifierProvider(create: (_) => UserProvider()),
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
            print("EEE --> ${snapshot.stackTrace}");
            return const Scaffold(
              body: Center(child: Text('Something went wrong')),
            );
          }

          final role = snapshot.data;
          print("ROLE --> $role");
          print("API --> ${dotenv.env['google_map_api']}");
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
    /*
    return FutureBuilder<String?>(
      future: _getRole(),
      builder: (context, snapshot) {
        // While loading → show splash or progress
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        // If error → show fallback screen
        if (snapshot.hasError) {
          print("EEE --> ${snapshot.stackTrace}");
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Something went wrong')),
            ),
          );
        }

        // Loaded → decide route
        final role = snapshot.data;
        return MaterialApp(
          title: 'Ghanta Gadi',
          debugShowCheckedModeBanner: false,
          theme: MyTheme().lightTheme,
          initialRoute: (role == null)
              ? AppRouter.login
              : (role == 'citizen')
              ? AppRouter.citizenHome
              : AppRouter.driverHome,
          onGenerateRoute: AppRouter.generateRoute,
        );

      },
    );

     */
  }
}
