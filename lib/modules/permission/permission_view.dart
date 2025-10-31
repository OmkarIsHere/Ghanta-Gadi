import 'package:flutter/material.dart';
import 'package:ghanta_gadi/core/extensions/values.dart';
import 'package:ghanta_gadi/providers/permission_provider.dart';
import 'package:provider/provider.dart' show Consumer;

import '../../core/widgets/show_toast.dart';

class PermissionView extends StatelessWidget {
  const PermissionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PermissionProvider>(
      builder: (context, provider, child) {
        return PopScope(
          canPop: provider.allPermissionsGranted,
          child: Scaffold(
            appBar: AppBar(title: Text('PERMISSIONS')),
            body: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.location_pin),
                  title: Text('Location Access', textAlign: TextAlign.start, style: context.text.labelLarge),
                  subtitle: Text('To get the current location', textAlign: TextAlign.start, style: context.text.bodySmall),
                  trailing: Switch(
                      value: provider.locationPermission,
                      onChanged: (value){
                        if(value) {
                          showBasicToast("Allow all the time permission", context);
                          provider.setLocationPermission(value);
                        }
                      }),
                ),
                ListTile(
                  leading: Icon(Icons.directions_walk),
                  title: Text('Activity Access', textAlign: TextAlign.start, style: context.text.labelLarge),
                  subtitle: Text('To track user activity', textAlign: TextAlign.start, style: context.text.bodySmall),
                  trailing: Switch(
                      value: provider.activityPermission,
                      onChanged: (value){
                        if(value) provider.setActivityPermission(value);
                      }),
                ),
                ListTile(
                  leading: Icon(Icons.battery_0_bar),
                  title: Text('Battery Access', textAlign: TextAlign.start, style: context.text.labelLarge),
                  subtitle: Text('To enable background service', textAlign: TextAlign.start, style: context.text.bodySmall),
                  trailing: Switch(
                      value: provider.batteryPermission,
                      onChanged: (value){
                        if(value) provider.setBatteryPermission(value);
                      }),
                ),
              ],
            )
          ),
        );
      },
    );
  }
}
