import 'package:flutter/material.dart';
import 'package:ghanta_gadi/core/constant/asset_constant.dart';
import 'package:ghanta_gadi/core/constant/dimension_constant.dart';
import 'package:ghanta_gadi/core/extensions/values.dart';

class DriverList extends StatelessWidget {
  const DriverList({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 15,
          bottom: 15,
          child: GestureDetector(
            onTap: (){},
            child: Container(
              padding: DimensionConstant.edgeInsetH10V10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: context.color.scrim,
              ),
                child: Icon(Icons.add, size: 28, color: context.color.primary),
            ),
          ),
        )
      ],
    );
  }
}
