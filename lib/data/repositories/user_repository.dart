import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:ghanta_gadi/data/services/notification_service.dart';

import '../../models/user.dart';
import '../services/firestore_service.dart';

class UserRepository {
  final FirestoreService fs;
  UserRepository(this.fs);

  Future<bool> createUser(String id, Map<String, dynamic> data) async {
    try {
      await fs.usersRef.doc(id).set(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> saveUserFcmToken(String userId) async {
    final token = await NotificationService.getFcmToken();
    if (token != null) {
      await fs.usersRef.doc(userId).update({
        'fcmToken': token,
      });
    }
  }

  Future<bool> saveUserHomeLocation({
    required String userId,
    required double lat,
    required double lng,
  }) async {
    final geoPoint = GeoFirePoint(GeoPoint(lat, lng));
    final userData = {
      'homeLocation': geoPoint.data,
      'lat': lat,
      'lng': lng,
    };
    await fs.usersRef.doc(userId).update(userData).onError((e,s)=> false);
    print('✅ Home location saved for user $userId');
    return true;
  }

  Future<DocumentSnapshot> getUserData(String id) async {
    final snapshot = await fs.usersRef.doc(id).get();
    return snapshot;
  }

  Future<List<User>> getAllDrivers() async {
    try {
      final querySnapshot = await fs.usersRef
          .where('role', isEqualTo: 'driver')
          .get();

      return querySnapshot.docs
          .map((doc) => User.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("❌ Error fetching drivers: $e");
      return [];
    }
  }

  Future<void> notifyNearbyUsers({
    required double vehicleLat,
    required double vehicleLng,
    required String vehicleId,
    double radiusInMeters = 100,
  }) async {
    try {
      final center = GeoFirePoint(GeoPoint(vehicleLat, vehicleLng));
      final radiusInKm = radiusInMeters / 1000;

      final nearbyUsersStream = await GeoCollectionReference(fs.usersRef)
            .fetchWithinWithDistance(
          center: center,
          radiusInKm: radiusInKm,
          field: 'homeLocation',
          geopointFrom: (Object? obj) {
            if (obj is Map && obj['geopoint'] is GeoPoint) {
              return obj['geopoint'] as GeoPoint;
            }
            return const GeoPoint(0.0, 0.0);
          },
        );

      if (nearbyUsersStream.isEmpty) {
        print('No users found within ${radiusInMeters.toInt()}m');
        return;
      }

      for (var doc in nearbyUsersStream) {
        final data = doc.documentSnapshot.data() as Map<String, dynamic>?;
        if (data == null) continue;

        final fcmToken = data['fcmToken'];
        if (fcmToken != null && fcmToken.toString().isNotEmpty) {
          await NotificationService().sendPushNotification(
            token: fcmToken,
            title: "Garbage Collection Vehicle Nearby",
            body: "Vehicle $vehicleId is within 100m of your location.",
          );
          print('Notification sent to user ${doc.documentSnapshot.id}');
        }
      }

    } catch (e) {
      print('❌ Error notifying nearby users: $e');
    }
  }

}
