import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/material.dart' show TextEditingController, GlobalKey, FormState;
import 'package:ghanta_gadi/core/constant/sf_constant.dart';
import 'package:ghanta_gadi/core/extensions/validation.dart';
import 'package:ghanta_gadi/data/repositories/location_repository.dart';
import 'package:ghanta_gadi/data/repositories/user_repository.dart';
import 'package:ghanta_gadi/data/services/auth_service.dart';
import 'package:ghanta_gadi/data/services/firestore_service.dart';

import '../core/helper/sf_helper.dart';
import '../core/misc/enum.dart';

class AuthProvider with ChangeNotifier{

  final locationRepository = LocationRepository(FirestoreService());
  final userRepository = UserRepository(FirestoreService());
  final authService = AuthService();

  final signupKey = GlobalKey<FormState>();
  final loginKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cnfPasswordController = TextEditingController();

  List<String>? cities;
  String? selectedCity;

  List<String>? wards;
  String? selectedWard;

  LoadState cityState = LoadState.LOADING;
  LoadState authState = LoadState.LOADED;

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

  Future<String> signup() async{

    authState = LoadState.LOADING;
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

    try {
      final result = await authService.registerUserWithEmailAndPassword(
        email: emailController.text.trimString,
        password: passwordController.text.trimString,
      );

      if (result.first == true) {
        final val = await userRepository.createUser(result.last, userData);
        resetForm();
        authState = LoadState.LOADED;
        notifyListeners();
        return val ? 'success' : 'fail';
      } else {
        authState = LoadState.LOADED;
        notifyListeners();
        return result[1] ?? 'Unknown error';
      }
    } catch (e) {
      authState = LoadState.LOADED;
      notifyListeners();
      return e.toString();
    }
  }

  Future<String> login() async{

    authState = LoadState.LOADING;
    notifyListeners();

    try {
      final result = await authService.loginUserWithEmailAndPassword(
        emailController.text.trimString,
        passwordController.text.trimString,
      );

      if (result.first == true) {
        final snapshot = await userRepository.getUserData(result.last);

        if(snapshot.exists){
          Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>;
          print("USER: ${userData["name"]}");
          print("USER: ${userData["role"]}");
          print("USER: ${userData["ward"]}");
          SFHelper.set(SfConstant.uId, result.last);
          SFHelper.set(SfConstant.uName, userData["name"]);
          SFHelper.set(SfConstant.uEmail, userData["email"]);
          SFHelper.set(SfConstant.uPhone, userData["phone"]);
          SFHelper.set(SfConstant.uRole, userData["role"]);
          SFHelper.set(SfConstant.uCity, userData["city"]);
          SFHelper.set(SfConstant.uWard, userData["ward"]);
          resetForm();
          authState = LoadState.LOADED;
          notifyListeners();
          return userData["role"];
        }else{
          authState = LoadState.LOADED;
          notifyListeners();
          return 'fail';
        }
      } else {
        authState = LoadState.LOADED;
        notifyListeners();
        return result[1] ?? 'Unknown error';
      }
    } catch (e) {
      authState = LoadState.LOADED;
      notifyListeners();
      return e.toString();
    }
  }

  void resetForm(){
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    cnfPasswordController.clear();
    signupKey.currentState?.reset();
  }

}