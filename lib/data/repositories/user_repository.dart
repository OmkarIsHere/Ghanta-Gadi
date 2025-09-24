import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';

class UserRepository {
  final FirestoreService fs;

  UserRepository(this.fs);

  // Future<bool> createUser(String id, Map<String, dynamic> data) async {
  //   await fs.usersRef.doc(id).set(data).then((val){
  //     return true;
  //   }).onError((error, stackTrace){
  //     return false;
  //   });
  //   return true;
  // }

  Future<bool> createUser(String id, Map<String, dynamic> data) async {
    try {
      await fs.usersRef.doc(id).set(data);
      return true;
    } catch (e) {
      print("Firestore error: $e");
      return false;
    }
  }

  // Future<DocumentSnapshot> getUserData(String id) {
  //   print("USER: -- ${fs.usersRef.doc(id).get()}");
  //   return fs.usersRef.doc(id).get();
  // }

  Future<DocumentSnapshot> getUserData(String id) async {
    final snapshot = await fs.usersRef.doc(id).get();
    print("USER DATA: ${snapshot.data}");
    return snapshot;
  }

}
