import 'package:flutter/material.dart';
import 'package:ghanta_gadi/core/extensions/values.dart';

import '../constant/dimension_constant.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.bgColor, this.width = double.maxFinite, this.height = 58, required this.label, required this.voidCallback});
  final String label;
  final Color bgColor;
  final double width;
  final double height;
  final VoidCallback voidCallback;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          fixedSize: Size(width,height),
          backgroundColor: bgColor,
          padding: DimensionConstant.edgeInsetV10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          )),
      onPressed: voidCallback,
      child: Text(label, style: context.text.titleSmall!.copyWith(color: Colors.white, letterSpacing: 1.3)),
    );
  }
}
