import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';

class UserRepository {
  final FirestoreService fs;

  UserRepository(this.fs);

  Future<bool> createUser(String id, Map<String, dynamic> data) async {
    await fs.usersRef.doc(id).set(data).then((val){
      return true;
    }).onError((error, stackTrace){
      return false;
    });
    return true;
  }

  Stream<DocumentSnapshot> getUserStream(String id) {
    return fs.usersRef.doc(id).snapshots();
  }
}
