import 'dart:async' show Completer;

import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/services/background_service.dart';

class MapProvider with ChangeNotifier{

  final service = FlutterBackgroundService();
  final Completer<GoogleMapController> controller = Completer<GoogleMapController>();

  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  Future<void> startService()async {
    await initializeBackgroundService();
    await service.startService();
  }

  void stopService(){
    service.invoke('stopService');
  }
}