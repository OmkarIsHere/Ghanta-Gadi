import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ghanta_gadi/modules/auth/login.dart';
import 'package:ghanta_gadi/providers/auth_provider.dart';
import 'package:ghanta_gadi/routes.dart';
import 'package:provider/provider.dart' show MultiProvider, ChangeNotifierProvider;

import 'core/config/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ghanta Gadi',
      debugShowCheckedModeBanner: false,
      theme: MyTheme().lightTheme,
      initialRoute: AppRouter.login,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
