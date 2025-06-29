import 'package:evently_app/model/event.dart';
import 'package:evently_app/providers/event_list_provider.dart';
import 'package:evently_app/utilis/app_colors.dart';
import 'package:evently_app/utilis/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapTab extends StatefulWidget {
  static const String routeName = 'map';

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  GoogleMapController? _mapController;
  LatLng? _myLocation;
  Set<Marker> _markers = {};
  double? distanceInMeters;
  String? _selectedEventId;

  @override
  void initState() {
    super.initState();
    _getMyLocation();
  }

  Future<void> _getMyLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) {
        // لا يمكن طلب صلاحية مرة تانية
        return;
      }

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _myLocation = LatLng(position.latitude, position.longitude);
      });

      print("📍 Location: $_myLocation");
    } catch (e) {
      print('❌ Error getting location: $e');
    }
  }

  void _calculateDistance(Event event) {
    if (_myLocation == null) return;

    final dist = Geolocator.distanceBetween(
      _myLocation!.latitude,
      _myLocation!.longitude,
      event.lat!,
      event.lng!,
    );
    setState(() {
      distanceInMeters = dist;
      _selectedEventId = event.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventListProvider = Provider.of<EventListProvider>(context);
    final events = eventListProvider.eventList;

    _markers = events
        .where((e) => e.lat != null && e.lng != null)
        .map((e) => Marker(
              markerId: MarkerId(e.id),
              position: LatLng(e.lat!, e.lng!),
              infoWindow: InfoWindow(title: e.title),
            ))
        .toSet();

    return Scaffold(
      body: _myLocation == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _myLocation!,
                    zoom: 14,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  onMapCreated: (controller) => _mapController = controller,
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return GestureDetector(
                          onTap: () {
                            if (event.lat != null && event.lng != null) {
                              _calculateDistance(event);
                              _mapController?.animateCamera(
                                CameraUpdate.newLatLngZoom(
                                    LatLng(event.lat!, event.lng!), 16),
                              );
                            }
                          },
                          child: Container(
                            width: 230,
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.primaryLight),
                              image: DecorationImage(
                                image: AssetImage(event.image),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withValues(alpha: 0.8),
                                    BlendMode.darken),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(event.title,
                                      style: AppStyles.bold16White),
                                  Text('${event.city}, ${event.country}',
                                      style: AppStyles.medium14White),
                                  if (_selectedEventId == event.id &&
                                      distanceInMeters != null)
                                    Text(
                                      '${(distanceInMeters! / 1000).toStringAsFixed(2)} km away',
                                      style: AppStyles.medium14White,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
