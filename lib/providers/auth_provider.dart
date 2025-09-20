import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show ChangeNotifier, FormState, GlobalKey;
import 'package:ghanta_gadi/core/extensions/validation.dart';
import 'package:ghanta_gadi/data/repositories/location_repository.dart';
import 'package:ghanta_gadi/data/repositories/user_repository.dart';
import 'package:ghanta_gadi/data/services/auth_service.dart';
import 'package:ghanta_gadi/data/services/firestore_service.dart';

import '../core/misc/enum.dart';

class AuthProvider with ChangeNotifier{

  final locationRepository = LocationRepository(FirestoreService());
  final userRepository = UserRepository(FirestoreService());
  final authService = AuthService();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cnfPasswordController = TextEditingController();

  List<String>? cities;
  String? selectedCity;

  List<String>? wards;
  String? selectedWard;

  LoadState state = LoadState.LOADING;
  LoadState signUpState = LoadState.LOADED;

  Future<void> loadCities() async {
    state = LoadState.LOADING;
    cities = [];
    wards?.clear();
    cities!.add('Select City');
    notifyListeners();
    cities = await locationRepository.loadCities().onError((e,s){
      state = LoadState.ERROR;
      return [];
    });

    state = LoadState.LOADED;
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

  Future<dynamic> signup() async{

    signUpState = LoadState.LOADING;
    notifyListeners();

    final Map<String, dynamic> userData = {
      "name": nameController.text.trimString,
      "role": "citizen",
      "email": emailController.text.trimString,
      "phone": phoneController.text.trimString,
      "password": passwordController.text.trimString,
      "city": selectedCity,
      "ward": selectedWard,
      "createdAt": DateTime.now(),
    };

    await authService.registerUserWithEmailAndPassword(email: emailController.text.trimString, password: passwordController.text.trimString).then((result) async{
      print("RESULT: $result");
      if(result.first == true) {
        await userRepository.createUser(result.last, userData).then((val){
          resetForm();
          signUpState = LoadState.LOADED;
          return val;
        });
      }else{
        return result[1];
      }
    }).onError((e,s){
      print("ERROR: ${e.toString()}");
      return e.toString();
    });
    signUpState = LoadState.LOADED;
    notifyListeners();
  }

  void resetForm(){
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    cnfPasswordController.clear();
  }

}