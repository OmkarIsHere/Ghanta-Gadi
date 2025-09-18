import '../services/firestore_service.dart';

class LocationRepository {
  final FirestoreService fs;

  LocationRepository(this.fs);

  Future<List<String>> loadCities() async {
    final snapshot = await fs.citiesRef.get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<String>> loadWards(String city) async {
    final snapshot = await fs.citiesRef
        .doc(city)
        .collection("wards")
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

}
