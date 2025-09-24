import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ghanta_gadi/core/constant/sf_constant.dart';
import 'package:ghanta_gadi/providers/auth_provider.dart';
import 'package:ghanta_gadi/routes.dart';
import 'package:provider/provider.dart' show MultiProvider, ChangeNotifierProvider;

import 'core/config/theme.dart';
import 'core/helper/sf_helper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SFHelper.init();

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
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
  }
}
