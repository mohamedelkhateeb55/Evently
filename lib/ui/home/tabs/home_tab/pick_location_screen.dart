import 'package:evently_app/utilis/app_colors.dart';
import 'package:evently_app/utilis/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickLocationScreen extends StatefulWidget {
  static const routeName = 'pick_location';

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  LatLng? _selectedPosition;
  Marker? _marker;

  @override
  void initState() {
    super.initState();
    _getMyLocation();
  }

  Future<void> _getMyLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _marker = Marker(
        markerId: MarkerId("initial"),
        position: _currentPosition!,
      );
    });
  }

  void _onTap(LatLng latLng) {
    setState(() {
      _selectedPosition = latLng;
      _marker = Marker(
        markerId: MarkerId("selected"),
        position: latLng,
      );
    });
  }

  Future<void> _confirmSelection() async {
    if (_selectedPosition == null) return;

    // reverse geocode
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _selectedPosition!.latitude, _selectedPosition!.longitude);

    final placemark = placemarks.first;
    final locationInfo = {
      'latLng': _selectedPosition,
      'city': placemark.locality ?? '',
      'country': placemark.country ?? '',
    };

    Navigator.pop(context, locationInfo);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 15,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  markers: _marker != null ? {_marker!} : {},
                  onTap: _onTap,
                ),
              ],
            ),
      bottomNavigationBar: Container(
        color: AppColors.primaryLight,
        padding: EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 30,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
            ),
            onPressed: _selectedPosition != null ? _confirmSelection : null,
            child: Text(
              _selectedPosition == null
                  ? "Tap on the map to select location"
                  : "Confirm Location",
              style: AppStyles.medium20White,
            ),
          ),
        ),
      ),
    );
  }
}
