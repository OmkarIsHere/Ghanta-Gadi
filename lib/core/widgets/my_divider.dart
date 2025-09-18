import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({super.key, required this.thickness, required this.color, this.height = 0});
  final double thickness;
  final double height;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Divider(thickness: thickness, height: height, color: color);
  }
}
