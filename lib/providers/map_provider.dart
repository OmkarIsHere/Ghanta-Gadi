import 'dart:async' show Completer;

import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/repositories/live_location_repository.dart';
import '../data/services/background_service.dart';
import '../data/services/realtime_service.dart';

class MapProvider with ChangeNotifier{

  final service = FlutterBackgroundService();
  final locationRepository = LiveLocationRepository(RealtimeService());

  final Completer<GoogleMapController> controller = Completer<GoogleMapController>();

  List<Map<String, dynamic>> vehicles = [];

  Stream<List<Map<String, dynamic>>>? _locationStream;
  Stream<List<Map<String, dynamic>>>? get locationStream => _locationStream;

  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(19.48, 22.08),
    zoom: 13,
  );

  Future<void> startService()async {
    await initializeBackgroundService();
    await service.startService();
  }

  void stopService(){
    service.invoke('stopService');
  }

  void listenToVehiclesLocation() {
    _locationStream = locationRepository.liveVehiclesLocation();
    _locationStream!.listen((data) {
      vehicles = data;
      kGooglePlex = CameraPosition(
        target: LatLng(vehicles.first['lat'] ?? 0, vehicles.first['lng'] ?? 0),
        zoom: 13,
      );
      notifyListeners();
    });
  }

  void stopListening() {
    _locationStream = null;
    vehicles.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}