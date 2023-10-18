import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' hide LatLng;

class TrackingPage extends StatefulWidget {
  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  GoogleMapController? _controller;
  final LatLng _center = const LatLng(
      0, 0); // Use the LatLng class from the google_maps_flutter package

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'In Transit',
          style: TextStyle(color: Color(0xFF232937), fontSize: 24),
        ),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 10, // Adjust the zoom level as need  ed
        ),
      ),
    );
  }
}
