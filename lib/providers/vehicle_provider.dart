import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:ghanta_gadi/core/constant/sf_constant.dart';
import 'package:ghanta_gadi/core/helper/sf_helper.dart';

import '../core/misc/enum.dart';
import '../data/repositories/vehicle_repository.dart';
import '../data/services/firestore_service.dart';
import 'map_provider.dart';

class VehicleProvider extends ChangeNotifier{

  final vehicleRepository = VehicleRepository(FirestoreService());
  final mapProvider = MapProvider();

  bool isOnDuty = false;

  List<Map<String, String>>? vehicles;
  String? selectedVehicle;
  LoadState vehicleState = LoadState.LOADING;
  LoadState onDutyState = LoadState.LOADED;

  List<String>? capacity= ['Empty', 'Half', 'Full'];
  String? currentCapacity;

  void changeDutyState(bool value){
    isOnDuty = value;
    notifyListeners();
  }

  void setSelectedVehicle(String vehicle) {
    selectedVehicle = vehicle;
    notifyListeners();
  }

  void setCurrentCapacity(String capacity) {
    currentCapacity = capacity;
    notifyListeners();
  }

  Future<String> getDriverOnDutyStatus() async{
    final uId = await SFHelper.get(SfConstant.uId);
    final vehicleId = await vehicleRepository.getVehicleIdByDriver(uId?? '');
    if(vehicleId != null && vehicleId.isNotEmpty){
      changeDutyState(true);
      mapProvider.startService();
    }else{
      mapProvider.stopService();
    }
    return vehicleId??'';
  }

  Future<void> getVehiclesData() async{
    vehicleState = LoadState.LOADING;
    notifyListeners();

    final snapshot = await vehicleRepository.getAllVehicleData().onError((e,s){
      vehicleState = LoadState.ERROR;
      notifyListeners();
      return [];
    });
    // vehicles = snapshot
    //     .where((v) => (v['driver'] ?? '').isEmpty)
    //     .map<String>((v) => v['numPlate'] ?? '')
    //     .where((plate) => plate.isNotEmpty)
    //     .toList();
    vehicles = snapshot
        .where((v) => (v['driver'] ?? '').isEmpty)
        .map<Map<String, String>>((v) => {
      'vehicleId': v['vehicleId'] ?? '',
      'numPlate': v['numPlate'] ?? '',
    }).where((vehicle) => vehicle['numPlate']!.isNotEmpty).toList();
    vehicleState = LoadState.LOADED;
    notifyListeners();
  }

  Future<bool?> assignVehicleDriver() async{
    if(selectedVehicle == null || selectedVehicle!.isEmpty) return null;

    onDutyState = LoadState.LOADING;
    notifyListeners();
    try {
      final uId = await SFHelper.get(SfConstant.uId);
      final result = await vehicleRepository.assignDriverToVehicle(
        selectedVehicle??'',
        uId?? '',
        currentCapacity??''
      );

      if(result){
        isOnDuty = true;
        mapProvider.startService();
      }
      onDutyState = LoadState.LOADED;
      notifyListeners();
      return result;

    } catch (e) {
      onDutyState = LoadState.ERROR;
      notifyListeners();
      return false;
    }
  }

  Future<bool?> removeVehicleDriver() async{

    onDutyState = LoadState.LOADING;
    notifyListeners();
    try {

      final vehicleId = await getDriverOnDutyStatus();
      final result = await vehicleRepository.clearDriverField(vehicleId);

      if(result){
        changeDutyState(false);
        mapProvider.stopService();
      }
      onDutyState = LoadState.LOADED;
      notifyListeners();
      return result;

    } catch (e) {
      onDutyState = LoadState.ERROR;
      notifyListeners();
      return false;
    }
  }
}