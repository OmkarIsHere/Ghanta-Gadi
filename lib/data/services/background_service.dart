import 'dart:async' show Timer;

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ghanta_gadi/data/services/location_service.dart';
import 'package:ghanta_gadi/data/services/realtime_service.dart';

import '../../core/constant/sf_constant.dart';
import '../../core/helper/sf_helper.dart';
import '../repositories/live_location_repository.dart';
import '../repositories/vehicle_repository.dart';
import 'firestore_service.dart' show FirestoreService;

@pragma('vm:entry-point')
Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onServiceStart,
      isForegroundMode: true,
      autoStart: false,
      initialNotificationTitle: "Ghanta Gadi Tracker",
      initialNotificationContent: "You are on duty",
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onServiceStart,
    ),
  );
}

@pragma('vm:entry-point')
Future<void> onServiceStart(ServiceInstance service) async {
  await Firebase.initializeApp();
  await SFHelper.init();

  final liveLocationRepository = LiveLocationRepository(RealtimeService());
  final vehicleRepository = VehicleRepository(FirestoreService());
  final locationService = LocationService();

  Timer? timer;

  timer = Timer.periodic(const Duration(seconds: 30), (t) async {
    final hasPermission = await locationService.checkAndRequestPermissions();
    if (!hasPermission) return;

    final position = await locationService.getCurrentPosition();
    if (position == null) return;

    final double speed = position.speed;
    final String status = speed > 2 ? "moving" : "idle";

    final uId = await SFHelper.get(SfConstant.uId);
    final uCity = await SFHelper.get(SfConstant.uCity);
    final uWard = await SFHelper.get(SfConstant.uWard);
    final vehicleId = await vehicleRepository.getVehicleIdByDriver(uId??'');
    if (vehicleId == null) {
      print("No vehicle assigned to this driver.");
      service.stopSelf();
      return;
    }

    await liveLocationRepository.updateVehicleLocation(
      vehicleId: vehicleId,
      lat: position.latitude,
      lng: position.longitude,
      speed: speed,
      status: status,
      driverId: uId??'',
      city: uCity??'',
      ward: uWard??'',
    );
    print("Location updated: ${position.latitude}, ${position.longitude}");
  });

  service.on('stopService').listen((_) {
    timer?.cancel();
    service.stopSelf();
  });
}
