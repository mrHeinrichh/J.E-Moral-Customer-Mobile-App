import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:customer_app/view/my_orders.page.dart';
import 'package:http/http.dart' as http;

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final GlobalKey<_MapsPageState> _key = GlobalKey();
  late Transaction transaction;
  List<LatLng> routePoints = [];

  void parseWaypoints(Map<String, dynamic> routingData) {
    try {
      List<dynamic> coordinates =
          routingData['features'][0]['geometry']['coordinates'];

      for (var coordinateSet in coordinates) {
        for (var coordinate in coordinateSet) {
          double latitude = coordinate[1].toDouble();
          double longitude = coordinate[0].toDouble();
          routePoints.add(LatLng(latitude, longitude));
        }
      }
    } catch (e) {
      print('Error parsing waypoints: $e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    transaction = ModalRoute.of(context)!.settings.arguments as Transaction;
    print(transaction.id);
    fetchData();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Maps',
          style: TextStyle(color: Color(0xFF232937), fontSize: 24),
        ),
      ),
      body: Container(
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(
              14.549095,
              121.027211,
            ),
            zoom: 12.5,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://maps.geoapify.com/v1/tile/klokantech-basic/{z}/{x}/{y}.png?apiKey=3e4c0fcabf244021845380f543236e29',
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: routePoints,
                  strokeWidth: 9.0,
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://lpg-api-06n8.onrender.com/api/v1/transactions/${transaction.id}',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print(response.body);

        // Get deliveryLocation from the data
        final String deliveryLocation = data['data']['deliveryLocation'];
        final String startLatitude = data['data']['lat'];
        final String startLongitude = data['data']['long'];
        print(
            'START LOCATION Latitude: $startLatitude, Longitude: $startLongitude');

        // Call the method to convert the address to coordinates
        await getAddressCoordinates(
            deliveryLocation, startLatitude, startLongitude);
      } else {
        print('Failed to load additional data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching additional data: $e');
    }
  }

  Future<void> getAddressCoordinates(
      String address, String startLatitude, String startLongitude) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.geoapify.com/v1/geocode/search?text=$address&apiKey=3e4c0fcabf244021845380f543236e29',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final double latitude = data['features'][0]['properties']['lat'];
        final double longitude = data['features'][0]['properties']['lon'];

        print('END LOCATION Latitude: $latitude, Longitude: $longitude');

        // Now, you can use the start and end coordinates to fetch routing information
        await getRoutingInformation(
            '$startLatitude,$startLongitude', '$latitude,$longitude');
      } else {
        print('Failed to get coordinates: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting coordinates: $e');
    }
  }

  Future<void> getRoutingInformation(
      String startCoordinates, String endCoordinates) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.geoapify.com/v1/routing?waypoints=$startCoordinates%7C$endCoordinates&mode=motorcycle&apiKey=3e4c0fcabf244021845380f543236e29',
        ),
      );

      print('Start Coordinates: $startCoordinates');
      print('End Coordinates: $endCoordinates');

      if (response.statusCode == 200) {
        final Map<String, dynamic> routingData = jsonDecode(response.body);
        print('Routing Information: $routingData');

        // Try to parse waypoints
        parseWaypoints(routingData);
      } else {
        print('Failed to get routing information: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting routing information: $e');
    }
  }
}
