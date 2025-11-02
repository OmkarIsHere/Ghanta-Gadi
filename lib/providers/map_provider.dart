import 'dart:async' show Completer;
import 'dart:ui' as ui show instantiateImageCodec, Codec, FrameInfo, ImageByteFormat;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../core/constant/asset_constant.dart';
import '../core/constant/sf_constant.dart';
import '../core/helper/sf_helper.dart';
import '../data/repositories/live_location_repository.dart';
import '../data/repositories/vehicle_repository.dart';
import '../data/services/background_service.dart';
import '../data/services/firestore_service.dart';
import '../data/services/realtime_service.dart';

class MapProvider with ChangeNotifier{

  final service = FlutterBackgroundService();
  final vehicleRepository = VehicleRepository(FirestoreService());
  final locationRepository = LiveLocationRepository(RealtimeService());

  final Completer<GoogleMapController> controller = Completer<GoogleMapController>();

  List<Map<String, dynamic>> vehicles = [];
  BitmapDescriptor? truckIcon;

  Stream<List<Map<String, dynamic>>>? _locationStream;
  Stream<List<Map<String, dynamic>>>? get locationStream => _locationStream;

  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(19.0760, 72.8777),
    zoom: 10,
  );

  MapProvider(){
    _loadTruckIcon();
  }

  Future<void> startService()async {
    await initializeBackgroundService();
    await service.startService();
  }

  void stopService(){
    service.invoke('stopService');
  }

  Future<void> _loadTruckIcon() async {
    final Uint8List markerIcon = await _getBytesFromAsset(AssetConstant.garbageTruckTopView, 90);
    truckIcon = BitmapDescriptor.bytes(markerIcon);
    notifyListeners();
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void listenToVehiclesLocation() {
    vehicles.clear();
    _locationStream = locationRepository.liveVehiclesLocation();
    _locationStream!.listen((data) {
      vehicles = data;
      if(vehicles.isNotEmpty){
        kGooglePlex = CameraPosition(
          target: LatLng(vehicles.first['lat'] ?? 0.0, vehicles.first['lng'] ?? 0.0),
          zoom: 13,
        );
      }
      notifyListeners();
    });
  }

  Future<void> listenToDriverVehiclesLocation() async{
    final uId = await SFHelper.get(SfConstant.uId);
    final vehicleId = await vehicleRepository.getVehicleIdByDriver(uId?? '');
    vehicles.clear();
    if(vehicleId != null && vehicleId.isNotEmpty) {
      _locationStream = locationRepository.liveVehicleLocation(vehicleId);
      _locationStream!.listen((data) {
        vehicles = data;
        if (vehicles.isNotEmpty) {
          kGooglePlex = CameraPosition(
            target: LatLng(vehicles.first['lat'] ?? 0.0, vehicles.first['lng'] ?? 0.0),
            zoom: 13,
          );
        }
        notifyListeners();
      });
    }
  }

  Future<void> listenToWardVehiclesLocation() async{
    final city = await SFHelper.get(SfConstant.uCity);
    final ward = await SFHelper.get(SfConstant.uWard);
    vehicles.clear();
    _locationStream = locationRepository.liveVehiclesLocationForCitizen(city: city??'', ward: ward??'');
    _locationStream!.listen((data) {
      vehicles = data;
      if(vehicles.isNotEmpty){
        kGooglePlex = CameraPosition(
          target: LatLng(vehicles.first['lat'] ?? 0.0, vehicles.first['lng'] ?? 0.0),
          zoom: 13,
        );
      }
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