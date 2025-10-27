import 'package:cloud_firestore/cloud_firestore.dart';

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


}
