import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  final Location location = Location();

  Future<String> reverseGeocode(double latitude, double longitude) async {
    final apiKey = '51dbec4c848141a991dc2a9d5020f252';
    final apiUrl =
        'https://api.geoapify.com/v1/geocode/reverse?lat=$latitude&lon=$longitude&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('features')) {
          final feature = data['features'][0];
          final formattedAddress = feature['properties']['formatted'] as String;

          return formattedAddress;
        } else {
          return 'No "features" key in the API response.';
        }
      } else {
        return 'API Request Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}

class LocationButtonWidget extends StatelessWidget {
  final Function(String) onLocationChanged;

  LocationButtonWidget({required this.onLocationChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextButton(
        onPressed: () async {
          try {
            LocationService locationService = LocationService();
            bool serviceEnabled =
                await locationService.location.serviceEnabled();
            if (!serviceEnabled) {
              serviceEnabled = await locationService.location.requestService();
              if (!serviceEnabled) {
                return;
              }
            }

            PermissionStatus permission =
                await locationService.location.hasPermission();
            if (permission == PermissionStatus.denied) {
              permission = await locationService.location.requestPermission();
              if (permission != PermissionStatus.granted) {
                return;
              }
            }

            LocationData currentLocation =
                await locationService.location.getLocation();
            double latitude = currentLocation.latitude ?? 0.0;
            double longitude = currentLocation.longitude ?? 0.0;

            print('Latitude: $latitude, Longitude: $longitude');

            String address =
                await locationService.reverseGeocode(latitude, longitude);
            onLocationChanged(address);
          } catch (e) {
            print('Error getting location: $e');
          }
        },
        child: const Text(
          "Use my current location",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
