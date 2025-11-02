import 'package:flutter/material.dart';
import 'package:ghanta_gadi/core/extensions/custom_widgets.dart';
import 'package:ghanta_gadi/core/extensions/margin.dart';
import 'package:ghanta_gadi/core/extensions/padding.dart';
import 'package:ghanta_gadi/core/extensions/values.dart';
import 'package:ghanta_gadi/core/misc/spacing.dart';
import 'package:ghanta_gadi/core/widgets/live_map.dart';
import 'package:ghanta_gadi/data/services/notification_service.dart';
import 'package:ghanta_gadi/providers/vehicle_provider.dart';
import 'package:provider/provider.dart' show Consumer, Provider;

import '../../core/constant/dimension_constant.dart';
import '../../core/misc/enum.dart';
import '../../core/widgets/loader.dart';
import '../../core/widgets/logout_popup.dart';
import '../../core/widgets/show_toast.dart';
import '../../providers/map_provider.dart';
import '../../providers/permission_provider.dart';
import '../../routes.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<VehicleProvider>(context, listen: false).getDriverOnDutyStatus();
      Provider.of<MapProvider>(context, listen: false).listenToDriverVehiclesLocation();
      if(!Provider.of<PermissionProvider>(context, listen: false).allPermissionsGranted
          && Provider.of<PermissionProvider>(context, listen: false).checkedAllPermissions){
        Navigator.pushNamed(context, AppRouter.permission);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DRIVER'),
        actions: [
          Consumer<VehicleProvider>(
            builder: (context, vehicleProvider, child) {
              return Switch.adaptive(
                value: vehicleProvider.isOnDuty,
                onChanged: (value) {
                  if (value){
                    vehicleProvider.getVehiclesWithoutDriver();
                    _showInputDialog(context);
                  }else{
                    vehicleProvider.removeVehicleDriver().then((res){
                      if(res == null){
                        showCustomToast("All fields are mandatory", context);
                      }else if(res){
                        showBasicToast("You are now off duty", context);
                      }else{
                        showCustomToast("Something went wrong", context);
                      }
                    });
                  }
                },
              );
            },
          ),
          Consumer<VehicleProvider>(
            builder: (context, vehicleProvider, child) {
              return Icon(Icons.logout, color: context.color.error)
                  .paddingSymmetric(edgeInsets: DimensionConstant.edgeInsetH10)
                  .inkWell(onTap: (){
                if(vehicleProvider.isOnDuty){
                  showBasicToast("First go off duty then log out", context);
                }else{
                  showLogoutPopUpDialog(context);
                }
              });
            },
          )
        ],
      ),
      body: LiveMap(),
    );
  }

  void _showInputDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Consumer<VehicleProvider>(
          builder: (context, vehicleProvider, child) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              title: const Text('On Duty Details'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (vehicleProvider.vehicleState == LoadState.LOADING) Center(child: CircularProgressIndicator()),
                  if (vehicleProvider.vehicleState == LoadState.ERROR) Text("Failed to load vehicles"),
                  if (vehicleProvider.vehicleState == LoadState.LOADED) Container(
                    padding: DimensionConstant.edgeInsetH10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.color.outline, width: 1),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: vehicleProvider.selectedVehicle,
                      hint: Text('Select Vehicle', style: context.text.titleSmall!.copyWith(color: context.color.tertiary),),
                      items: vehicleProvider.vehiclesWithoutDrivers!
                          .map((vehicle) =>
                          DropdownMenuItem<String>(
                              value: vehicle['vehicleId'],
                              child: Text(vehicle['numPlate']!, style: context.text.labelLarge,),
                          ))
                          .toList(),
                      onChanged: (value) {
                        vehicleProvider.setSelectedVehicle(value!);
                      },
                      iconEnabledColor: context.color.tertiary,
                      underline: Container(color: Colors.transparent),
                    ),
                  ).marginSymmetric(edgeInsets: DimensionConstant.edgeInsetV10),
                  VSpace(5),
                  Container(
                    padding: DimensionConstant.edgeInsetH10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.color.outline, width: 1),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: vehicleProvider.currentCapacity,
                      hint: Text('Current Capacity', style: context.text.titleSmall!.copyWith(color: context.color.tertiary),),
                      items: vehicleProvider.capacity!
                          .map((capacity) =>
                          DropdownMenuItem<String>(
                              value: capacity,
                              child: Text(capacity, style: context.text.labelLarge,)))
                          .toList(),
                      onChanged: (value) {
                        vehicleProvider.setCurrentCapacity(value!);
                      },
                      iconEnabledColor: context.color.tertiary,
                      underline: Container(color: Colors.transparent),
                    ),
                  ).marginSymmetric(edgeInsets: DimensionConstant.edgeInsetV10),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: DimensionConstant.edgeInsetV10,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: context.color.outline, width: 1)
                      ),
                      child: Text(
                          'CANCEL',
                          style: context.text.titleSmall!.copyWith(color: context.color.secondary)
                      ),
                    ).inkWell(onTap: ()=> Navigator.pop(context)).expanded(flex: 1),
                    HSpace(10),
                    (vehicleProvider.onDutyState == LoadState.LOADED)
                        ? Container(
                      padding: DimensionConstant.edgeInsetV10,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: context.color.outline, width: 1)
                      ),
                      child: Text(
                          'SAVE',
                          style: context.text.titleSmall!.copyWith( color: context.color.primary)
                      ),
                    ).inkWell(onTap: (){
                      vehicleProvider.assignVehicleDriver().then((res){
                        if(res == null){
                          showCustomToast("All fields are mandatory", context);
                        }else if(res){
                          showBasicToast("You are now on duty", context);
                        }else{
                          showCustomToast("Something went wrong", context);
                        }
                        Navigator.pop(context);
                      });
                    }).expanded(flex: 1)
                        : loader()
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }
}
