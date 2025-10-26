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
        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: mapProvider.kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            mapProvider.controller.complete(controller);
          },
        );
      },
    );
  }
}
