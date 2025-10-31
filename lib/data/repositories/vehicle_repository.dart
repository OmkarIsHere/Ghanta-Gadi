import 'package:cloud_firestore/cloud_firestore.dart' show FieldValue, SetOptions, QuerySnapshot;

import '../../models/vehicle.dart';
import '../services/firestore_service.dart';

class VehicleRepository {

  final FirestoreService fs;

  VehicleRepository(this.fs);

  Future<bool> _addVehicle(Map<String, dynamic> data) async {
    try {
      await fs.vehiclesRef.add(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _addOrUpdateVehicle(Vehicle vehicle) async {
    try {
      await fs.vehiclesRef.add(vehicle.toJson());
      print("✅ Vehicle ${vehicle.vehicleId} added/updated successfully");
      return true;
    } catch (e) {
      print("❌ Error adding/updating vehicle: $e");
      return false;
    }
  }

  Future<bool> addOrUpdateVehicle(Vehicle vehicle) async {
    try {
      String vehicleId = vehicle.vehicleId.isEmpty
          ? fs.vehiclesRef.doc().id
          : vehicle.vehicleId;

      final updatedVehicle = vehicle.copyWith(vehicleId: vehicleId);

      await fs.vehiclesRef
          .doc(vehicleId)
          .set(updatedVehicle.toJson(), SetOptions(merge: true));

      print("✅ Vehicle ${updatedVehicle.vehicleId} added/updated successfully");
      return true;
    } catch (e) {
      print("❌ Error adding/updating vehicle: $e");
      return false;
    }
  }


  Future<List<Vehicle>> getAllVehicles() async {
    try {
      QuerySnapshot snapshot = await fs.vehiclesRef.get();
      return snapshot.docs
          .map((doc) => Vehicle.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("❌ Error fetching vehicles: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getVehiclesWithoutDriver() async {
    try {
      final snapshot = await fs.vehiclesRef.where('driver', isEqualTo: "")
          .get();
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      print("Error fetching vehicles: $e");
      return [];
    }
  }

  Future<bool> assignDriverToVehicle(String vehicleId, String driverId, String currentCapacity) async {
    try {
      await fs.vehiclesRef.doc(vehicleId).update({
        'driver': driverId,
        'currentCapacity': currentCapacity,
        'lastUpdated': FieldValue.serverTimestamp(),
      }).onError((e,s)=> false);
      return true;
    } catch (e) {
      print('Error assigning driver: $e');
      return false;
    }
  }

  Future<bool> clearDriverField(String vehicleId) async {
    try {
      await fs.vehiclesRef.doc(vehicleId).update({
        'driver': "",
      });
      print("Driver field cleared successfully for $vehicleId");
      return true;
    } catch (e) {
      print("Error clearing driver: $e");
      return false;
    }
  }

  Future<String?> getVehicleIdByDriver(String driverId) async {
    try {
      final snapshot = await fs.vehiclesRef
          .where('driver', isEqualTo: driverId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id;
      }
      return null;
    } catch (e) {
      print("Error fetching vehicle for driver: $e");
      return null;
    }
  }

}