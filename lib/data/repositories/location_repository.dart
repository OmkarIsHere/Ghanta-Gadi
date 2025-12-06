import 'dart:convert' show json;

import '../../models/place_suggestion.dart';
import '../services/firestore_service.dart';
import 'package:http/http.dart' as http;

class LocationRepository {

  final FirestoreService fs;
  final _locationUrl = "https://nominatim.openstreetmap.org/search";

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

  Future<List<PlaceSuggestion>> getSuggestions(String query) async {
    try {
      final url =
          "$_locationUrl?q=$query&format=json";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "User-Agent": "GadiAcademicApp/1.0 (contact: example@gmail.com)"
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return List<PlaceSuggestion>.from(
          body.map((item) => PlaceSuggestion.fromJson(item)),
        );
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to fetch places: $e");
    }
  }

}
