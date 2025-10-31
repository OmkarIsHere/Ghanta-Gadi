import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  final String vehicleId;
  final String modelName;
  final String numPlate;
  final String currentCapacity;
  final String driver;
  final DateTime lastUpdated;

  Vehicle({
    required this.vehicleId,
    required this.modelName,
    required this.numPlate,
    required this.currentCapacity,
    required this.driver,
    required this.lastUpdated,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleId: json['vehicleId'] ?? '',
      modelName: json['modelName'] ?? '',
      numPlate: json['numPlate'] ?? '',
      currentCapacity: json['currentCapacity'] ?? '',
      driver: json['driver'] ?? '',
      lastUpdated: (json['lastUpdated'] is Timestamp)
          ? (json['lastUpdated'] as Timestamp).toDate()
          : DateTime.tryParse(json['lastUpdated'] ?? '') ?? DateTime.now(),
    );
  }

  Vehicle copyWith({
    String? vehicleId,
    String? modelName,
    String? numPlate,
    String? driver,
    String? currentCapacity,
    DateTime? lastUpdated,
  }) {
    return Vehicle(
      vehicleId: vehicleId ?? this.vehicleId,
      modelName: modelName ?? this.modelName,
      numPlate: numPlate ?? this.numPlate,
      driver: driver ?? this.driver,
      currentCapacity: currentCapacity ?? this.currentCapacity,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'modelName': modelName,
      'numPlate': numPlate,
      'currentCapacity': currentCapacity,
      'driver': driver,
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }
}
