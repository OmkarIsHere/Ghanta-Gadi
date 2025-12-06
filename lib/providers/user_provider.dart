import 'package:flutter/foundation.dart';
import 'package:ghanta_gadi/models/user.dart';

import '../core/constant/sf_constant.dart';
import '../core/helper/sf_helper.dart';
import '../core/misc/enum.dart';
import '../data/repositories/location_repository.dart';
import '../data/repositories/user_repository.dart';
import '../data/services/firestore_service.dart';
import '../models/place_suggestion.dart';

class UserProvider extends ChangeNotifier{

  final locationRepository = LocationRepository(FirestoreService());
  final userRepository = UserRepository(FirestoreService());

  List<String>? cities;
  String? selectedCity;

  List<String>? wards;
  String? selectedWard;

  LoadState cityState = LoadState.LOADING;
  LoadState loadState = LoadState.LOADED;

  List<User> drivers = [];

  bool isLoading = false;
  String? errorMessage;
  List<PlaceSuggestion> suggestions = [];
  PlaceSuggestion? selectedPlace;

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

  Future<void> getAllDrivers() async {
    drivers = [];
    loadState = LoadState.LOADING;
    notifyListeners();
    await userRepository.getAllDrivers().then((values){
      drivers = values;
      loadState = LoadState.LOADED;
      notifyListeners();
    }).onError((e,s){
      loadState = LoadState.ERROR;
      notifyListeners();
      return;
    });
    notifyListeners();
  }

  Future<void> searchPlaces(String query) async {
    isLoading = true;
    errorMessage = null;
    suggestions = [];
    notifyListeners();

    try {
      suggestions = await locationRepository.getSuggestions(query);
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void selectSuggestedPlace(PlaceSuggestion place){
    selectedPlace = place;
  }

  Future<bool> saveHomeLocation() async {
    if(selectedPlace == null) return false;
    isLoading = true;
    errorMessage = null;
    bool result = false;
    suggestions = [];
    notifyListeners();
    final uId = await SFHelper.get(SfConstant.uId);
    try {
      result = await userRepository.saveUserHomeLocation(userId:uId!, lat: selectedPlace!.lat, lng: selectedPlace!.lon);
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    selectedPlace = null;
    notifyListeners();
    return result;
  }
}