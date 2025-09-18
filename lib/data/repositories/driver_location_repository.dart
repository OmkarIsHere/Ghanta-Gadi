import 'package:firebase_database/firebase_database.dart';

import '../services/realtime_service.dart';

class DriverLocationRepository {
  final RealtimeService rtdb;

  DriverLocationRepository(this.rtdb);

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

}
