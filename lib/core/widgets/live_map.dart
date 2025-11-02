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
          return GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            tiltGesturesEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: mapProvider.kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              mapProvider.controller.complete(controller);
            },
          );
        }

        final Set<Marker> markers = mapProvider.vehicles.map((vehicle) {
          final id = vehicle['id'];
          final name = vehicle['driverName'] ?? '';
          final lat = (vehicle['lat'] ?? 0).toDouble();
          final lng = (vehicle['lng'] ?? 0).toDouble();
          final speed = (vehicle['speed'] ?? 0).toDouble();
          final direction = (vehicle['direction'] ?? 0).toDouble();
          final status = vehicle['status'] ?? "unknown";

          return Marker(
            markerId: MarkerId(id),
            position: LatLng(lat, lng),
            anchor: const Offset(0.5, 0.5),
            rotation: direction,
            flat: true,
            icon: mapProvider.truckIcon!,
            infoWindow: InfoWindow(
              title: "Driver: $name",
              snippet: "Speed: ${speed.toStringAsFixed(1)} | Status: $status",
            ),
            // icon: BitmapDescriptor.defaultMarkerWithHue(
            //   status == "moving"
            //       ? BitmapDescriptor.hueGreen
            //       : BitmapDescriptor.hueRed,
            // ),
          );
        }).toSet();

        return GoogleMap(
          mapType: MapType.normal,
          markers: markers,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          tiltGesturesEnabled: false,
          minMaxZoomPreference: const MinMaxZoomPreference(5, 20),
          initialCameraPosition: mapProvider.kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            mapProvider.controller.complete(controller);
          },
        );
      },
    );
  }
}