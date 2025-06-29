import 'package:flutter/animation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkerHelper {
  static Marker createMarker({
    required String id,
    required LatLng position,
    required String title,
    double color = BitmapDescriptor.hueRed,
    VoidCallback? onTap,
  }) {
    return Marker(
      markerId: MarkerId(id),
      position: position,
      infoWindow: InfoWindow(title: title),
      icon: BitmapDescriptor.defaultMarkerWithHue(color),
      onTap: onTap,
    );
  }
}
