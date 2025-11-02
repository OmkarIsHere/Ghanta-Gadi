import '../services/realtime_service.dart';

class LiveLocationRepository {
  final RealtimeService rtdb;

  LiveLocationRepository(this.rtdb);

  Future<void> updateVehicleLocation({
    required String vehicleId,
    required String driverId,
    required String driverName,
    required double lat,
    required double lng,
    required double speed,
    required String status,
    required String city,
    required String ward,
    required double direction,
  }) async {
    try {
      await rtdb.vehicleLocationRef.child(vehicleId).set({
        'vehicleId': vehicleId,
        'driverId': driverId,
        'driverName': driverName,
        'lat': lat,
        'lng': lng,
        'speed': speed,
        'status': status,
        'city': city,
        'ward': ward,
        'direction': direction,
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

  Stream<List<Map<String, dynamic>>> liveVehicleLocation(String vehicleId) {
    return rtdb.vehicleLocationRef.child(vehicleId).onValue.map((event) {
      if (!event.snapshot.exists) return [];
      final vehicleData = Map<String, dynamic>.from(event.snapshot.value as Map);
      vehicleData['id'] = vehicleId;
      return [vehicleData];
    });
  }

  Stream<List<Map<String, dynamic>>> liveVehiclesLocation() {
    return rtdb.vehicleLocationRef.onValue.map((event) {
      if (!event.snapshot.exists) return [];

      final Map<String, dynamic> data = Map<String, dynamic>.from(event.snapshot.value as Map);

      return data.entries.map((e) {
        final vehicle = Map<String, dynamic>.from(e.value);
        vehicle['id'] = e.key;
        return vehicle;
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> liveVehiclesLocationForCitizen({
    required String city,
    required String ward,
  }) {
    return rtdb.vehicleLocationRef.onValue.map((event) {
      if (!event.snapshot.exists) return [];

      final Map<String, dynamic> data =
      Map<String, dynamic>.from(event.snapshot.value as Map);

      final filteredVehicles = data.entries.map((e) {
        final vehicle = Map<String, dynamic>.from(e.value);
        vehicle['id'] = e.key;
        return vehicle;
      }).where((vehicle) {
        final vCity = (vehicle['city'] ?? '').toString().trim().toLowerCase();
        final vWard = (vehicle['ward'] ?? '').toString().trim().toLowerCase();
        return vCity == city.toLowerCase() && vWard == ward.toLowerCase();
      }).toList();

      return filteredVehicles;
    });
  }


}
