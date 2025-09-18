import 'package:firebase_database/firebase_database.dart';

class RealtimeService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  DatabaseReference get driversRef => _db.ref("drivers");
}
