class PlaceSuggestion {
  final String displayName;
  final double lat;
  final double lon;

  PlaceSuggestion({
    required this.displayName,
    required this.lat,
    required this.lon,
  });

  factory PlaceSuggestion.fromJson(Map<String, dynamic> json) {
    return PlaceSuggestion(
      displayName: json['display_name'] ?? '',
      lat: double.tryParse(json['lat'] ?? '0') ?? 0,
      lon: double.tryParse(json['lon'] ?? '0') ?? 0,
    );
  }
}
