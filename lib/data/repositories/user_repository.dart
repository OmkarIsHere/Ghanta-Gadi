import 'package:cloud_firestore/cloud_firestore.dart';

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

}
