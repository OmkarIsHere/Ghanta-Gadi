import 'package:flutter/material.dart';
import 'package:ghanta_gadi/core/constant/dimension_constant.dart';
import 'package:ghanta_gadi/core/extensions/values.dart';
import 'package:ghanta_gadi/core/misc/enum.dart';
import 'package:ghanta_gadi/core/widgets/loader.dart';
import 'package:ghanta_gadi/core/widgets/show_toast.dart';
import 'package:ghanta_gadi/providers/vehicle_provider.dart';
import 'package:provider/provider.dart' show Consumer;

import '../../core/widgets/my_divider.dart';
import '../../routes.dart';

class VehicleList extends StatelessWidget {
  const VehicleList({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: context.mqHeight,
          width: context.mqWidth,
          child: Consumer<VehicleProvider>(
            builder: (context, vehicleProvider, child) {
              if(vehicleProvider.vehicleState == LoadState.LOADED) {
                return ListView.separated(
                  itemCount: vehicleProvider.vehicles.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: RichText(
                          text: TextSpan(
                              text: 'Model: ',
                              style: context.text.titleSmall,
                              children: [
                                TextSpan(
                                  text: vehicleProvider.vehicles[index].modelName,
                                  style: context.text.labelMedium,
                                )
                              ]
                          )
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: 'No Plate: ',
                                  style: context.text.titleSmall,
                                  children: [
                                    TextSpan(
                                      text:  vehicleProvider.vehicles[index].numPlate,
                                      style: context.text.labelMedium,
                                    )
                                  ]
                              )
                          ),
                          RichText(
                              text: TextSpan(
                                  text: 'Last Used: ',
                                  style: context.text.titleSmall,
                                  children: [
                                    TextSpan(
                                      text: vehicleProvider.vehicles[index].lastUpdated.toString(),
                                      style: context.text.labelMedium,
                                    )
                                  ]
                              )
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return MyDivider(
                        color: context.color.outline, thickness: 1);
                  },
                );
              }else if(vehicleProvider.vehicleState == LoadState.LOADING){
                return loader();
              }else{
                return showBasicToast("Something Went Wrong", context);
              }
            },
          ),
        ),
        Positioned(
          right: 15,
          bottom: 15,
          child: GestureDetector(
            onTap: (){
              Navigator.pushNamed(
                  context,
                  AppRouter.addVehicle);
            },
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
