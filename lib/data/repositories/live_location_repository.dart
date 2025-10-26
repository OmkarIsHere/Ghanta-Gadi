import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import '../services/realtime_service.dart';

class LiveLocationRepository {
  final RealtimeService rtdb;

  LiveLocationRepository(this.rtdb);

  Future<void> updateLocation(String driverId, double lat, double lng, String status) async {
    await rtdb.driversRef.child(driverId).set({
      "lat": lat,
      "lng": lng,
      "status": status,
      "lastUpdated": DateTime.now().millisecondsSinceEpoch,
    });
  }

  Stream<DatabaseEvent> getDriverLocation(String driverId) {
    return rtdb.driversRef.child(driverId).onValue;
  }

  Future<void> updateVehicleLocation({
    required String vehicleId,
    required String driverId,
    required double lat,
    required double lng,
    required double speed,
    required String status,
  }) async {
    try {
      await rtdb.vehicleLocationRef.child(vehicleId).set({
        'vehicleId': vehicleId,
        'driverId': driverId,
        'lat': lat,
        'lng': lng,
        'speed': speed,
        'status': status,
        'lastUpdated': DateTime.now().toString(),
      });
      print("✅ Vehicle location updated for $vehicleId");
    } catch (e) {
      print("❌ Error updating location: $e");
    }
  }

  Future<Map<String, dynamic>?> getVehicleLocation(String vehicleId) async {
    try {
      final snapshot = await rtdb.vehicleLocationRef.child(vehicleId).get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      print("❌ Error getting location: $e");
      return null;
    }
  }

  Stream<Map<String, dynamic>?> liveVehicleLocation(String vehicleId) {
    return rtdb.vehicleLocationRef.child(vehicleId).onValue.map((event) {
      if (event.snapshot.exists) {
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      }
      return null;
    });
  }


}
