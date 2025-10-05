import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:open_settings_plus/core/open_settings_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionProvider with ChangeNotifier{

  bool locationPermission = false;
  bool activityPermission = false;
  bool batteryPermission = false;

  PermissionProvider() {
    _checkAllPermissions();
  }

  // void setLocationPermission(bool value){
  //   locationPermission = value;
  //   notifyListeners();
  // }
  //
  // void setActivityPermission(bool value){
  //   activityPermission = value;
  //   notifyListeners();
  // }
  //
  // void setBatteryPermission(bool value){
  //   batteryPermission = value;
  //   notifyListeners();
  // }

  Future<void> _checkAllPermissions() async {
    locationPermission = await Permission.locationAlways.isGranted ||
        await Permission.locationWhenInUse.isGranted;

    activityPermission = await Permission.activityRecognition.isGranted;

    batteryPermission = (await DisableBatteryOptimization.isBatteryOptimizationDisabled)?? false;

    notifyListeners();
  }

  Future<void> setLocationPermission(bool value) async {
    if (value) {
      PermissionStatus status = await Permission.locationAlways.request();
      if (status.isGranted || status.isLimited) {
        locationPermission = true;
      } else if (status.isPermanentlyDenied || status.isDenied || status.isRestricted) {
        await OpenSettingsPlusAndroid().locationSource();
        _checkAllPermissions();
      } else if (status != Permission.locationAlways) {
        await OpenSettingsPlusAndroid().locationSource();
        _checkAllPermissions();
      } else {
        locationPermission = false;
      }
    } else {
      locationPermission = false;
    }
    notifyListeners();
  }

  Future<void> setActivityPermission(bool value) async {
    if (value) {
      final status = await Permission.activityRecognition.request();
      if (status.isGranted) {
        activityPermission = true;
      } else if (status.isPermanentlyDenied) {
        await OpenSettingsPlusAndroid().applicationSettings();
      } else {
        activityPermission = false;
      }
    } else {
      activityPermission = false;
    }
    notifyListeners();
  }

  Future<void> setBatteryPermission(bool value) async {
    if (value) {
      final isDisabled = await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
      if (isDisabled?? false) {
        batteryPermission = true;
      } else {
        batteryPermission = (await DisableBatteryOptimization.isBatteryOptimizationDisabled)?? false;
      }
    } else {
      batteryPermission = false;
    }
    notifyListeners();
  }
}