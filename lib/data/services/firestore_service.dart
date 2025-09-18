import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get usersRef => _db.collection("users");
  CollectionReference get complaintsRef => _db.collection("complaints");
  CollectionReference get vehiclesRef => _db.collection("vehicles");
  CollectionReference get citiesRef => _db.collection("cities");
}
