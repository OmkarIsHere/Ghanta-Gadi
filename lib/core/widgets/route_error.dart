import 'package:flutter/material.dart';

class RouteError extends StatelessWidget {
  const RouteError({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Route not found')),
    );
  }
}
