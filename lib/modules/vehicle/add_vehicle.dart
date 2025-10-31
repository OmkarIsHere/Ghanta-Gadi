import 'package:flutter/material.dart';
import 'package:ghanta_gadi/core/extensions/margin.dart';
import 'package:ghanta_gadi/core/extensions/padding.dart';
import 'package:ghanta_gadi/core/extensions/validation.dart';
import 'package:ghanta_gadi/core/extensions/values.dart';
import 'package:ghanta_gadi/providers/vehicle_provider.dart';
import 'package:provider/provider.dart' show Consumer;

import '../../core/constant/dimension_constant.dart';
import '../../core/misc/enum.dart';
import '../../core/misc/input_decoration.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/show_toast.dart';

class AddVehicle extends StatelessWidget {
  const AddVehicle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD VEHICLE'),
      ),
      body: Consumer<VehicleProvider>(
        builder: (context, provider, child) {
          return Form(
            key: provider.addVehicleKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    return (value!.trimString.isEmpty)
                        ? "Please enter a vehicle name"
                        : null;
                  },
                  controller: provider.vehicleNameController,
                  style: context.text.labelLarge,
                  decoration: textInputFieldDecoration(context).copyWith(
                    hintText: 'Enter vehicle model',
                    labelText: 'Vehicle Name',
                    prefixIcon: const Icon(Icons.directions_bus_outlined),
                    contentPadding: DimensionConstant.edgeInsetH10,
                  ),
                ).marginSymmetric(edgeInsets: DimensionConstant.edgeInsetV10),
                TextFormField(
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    return (value!.trimString.isNotEmpty)
                        ? null
                        : "Please enter a number plate";
                  },
                  controller: provider.vehicleNumPlateController,
                  style: context.text.labelLarge,
                  decoration: textInputFieldDecoration(context).copyWith(
                    hintText: 'MH00XX1234',
                    labelText: 'Number Plate',
                    prefixIcon: const Icon(Icons.numbers_outlined),
                    contentPadding: DimensionConstant.edgeInsetH10,
                  ),
                ).marginSymmetric(edgeInsets: DimensionConstant.edgeInsetV10),
                Spacer(),
                (provider.vehicleState == LoadState.LOADED)
                    ? CustomButton(
                    bgColor: context.color.primary,
                    label: 'REGISTER VEHICLE',
                    voidCallback: () async{
                      if(!provider.addVehicleKey.currentState!.validate()) return;
                      await provider.addVehicle()
                          .then((res) {
                        if (res == 'success') {
                          showCustomToast("Successfully register vehicle", context, isError: false);
                        } else if (res == 'fail') {
                          showCustomToast("Something went wrong", context);
                        } else {
                          showCustomToast(res.toString(), context);
                        }
                      });
                    })
                    : CircularProgressIndicator()
              ],
            ).paddingSymmetric(edgeInsets: DimensionConstant.edgeInsetH20V10));
        },
      ),
    );
  }
}
