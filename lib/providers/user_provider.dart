import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show GlobalKey, FormState, TextEditingController;

import '../core/misc/enum.dart';
import '../data/repositories/location_repository.dart';
import '../data/repositories/user_repository.dart';
import '../data/services/firestore_service.dart';

class UserProvider extends ChangeNotifier{

  final locationRepository = LocationRepository(FirestoreService());
  final userRepository = UserRepository(FirestoreService());

  final addDriverKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  List<String>? cities;
  String? selectedCity;

  List<String>? wards;
  String? selectedWard;

  LoadState cityState = LoadState.LOADING;
  LoadState addState = LoadState.LOADED;

  Future<void> loadCities() async {
    cityState = LoadState.LOADING;
    cities = [];
    wards?.clear();
    cities!.add('Select City');
    notifyListeners();
    cities = await locationRepository.loadCities().onError((e,s){
      cityState = LoadState.ERROR;
      return [];
    });

    cityState = LoadState.LOADED;
    notifyListeners();
  }

  void setSelectedCity(String city) {
    selectedCity = city;
    if(selectedCity != 'Select City') loadWards();
    notifyListeners();
  }

  Future<void> loadWards() async {
    wards = [];
    wards!.add('Select Ward');
    selectedWard = 'Select Ward';
    notifyListeners();
    await locationRepository.loadWards(selectedCity!).then((values){
      wards!.addAll(values);
      notifyListeners();
    }).onError((e,s){
      return;
    });
    notifyListeners();
  }

  void setSelectedWard(String ward) {
    selectedWard = ward;
    notifyListeners();
  }
}