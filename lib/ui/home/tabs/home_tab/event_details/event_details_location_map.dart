// file: event_details_location_map.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventDetailsLocationMap extends StatelessWidget {
  final LatLng? latLng;

  const EventDetailsLocationMap({Key? key, required this.latLng})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    if (latLng == null) {
      return const Text('No location selected.');
    }

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: width * 0.03),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 2)),
        child: SizedBox(
          height: 250,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: latLng!,
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('event_location'),
                  position: latLng!,
                ),
              },
              zoomControlsEnabled: false,
              liteModeEnabled: true,
            ),
          ),
        ),
      ),
    );
  }
}
