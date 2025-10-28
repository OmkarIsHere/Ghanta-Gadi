import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart' show Consumer;

import '../../providers/map_provider.dart';

class LiveMap extends StatelessWidget {
  const LiveMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) {

        if (mapProvider.vehicles.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final Set<Marker> markers = mapProvider.vehicles.map((vehicle) {
          final id = vehicle['id'];
          final lat = (vehicle['lat'] ?? 0).toDouble();
          final lng = (vehicle['lng'] ?? 0).toDouble();
          final speed = (vehicle['speed'] ?? 0).toDouble();
          final status = vehicle['status'] ?? "unknown";

          return Marker(
            markerId: MarkerId(id),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: "Vehicle: $id",
              snippet: "Speed: $speed | Status: $status",
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              status == "active"
                  ? BitmapDescriptor.hueGreen
                  : BitmapDescriptor.hueRed,
            ),
          );
        }).toSet();

        return GoogleMap(
          mapType: MapType.normal,
          markers: markers,
          initialCameraPosition: mapProvider.kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            mapProvider.controller.complete(controller);
          },
        );
      },
    );
  }
}
