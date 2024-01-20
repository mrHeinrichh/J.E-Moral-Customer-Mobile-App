import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:customer_app/view/my_orders.page.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final GlobalKey<_MapsPageState> _key = GlobalKey();
  late Transaction transaction;
  List<LatLng> routePoints = [];
  bool isLoading = true;
  late Timer timer; // Declare a Timer variable

  @override
  void initState() {
    super.initState();
    fetchData();

    // Start a timer to call fetchData every 3 seconds
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => fetchData());
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    transaction = ModalRoute.of(context)!.settings.arguments as Transaction;
    print(transaction.id);
    // fetchData();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Maps',
          style: TextStyle(color: Color(0xFF232937), fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else
            buildMap(),
        ],
      ),
    );
  }

  Widget buildMap() {
    double minLat = double.infinity;
    double maxLat = double.negativeInfinity;
    double minLng = double.infinity;
    double maxLng = double.negativeInfinity;

    for (LatLng point in routePoints) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }
    LatLng center = LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2);
    double zoom = calculateZoom(minLat, maxLat, minLng, maxLng);

    return Expanded(
      child: FlutterMap(
        options: MapOptions(
          center: center,
          zoom: zoom,
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
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 60.0,
                point:
                    routePoints.isNotEmpty ? routePoints.first : LatLng(0, 0),
                builder: (ctx) => CustomMarker(
                  iconUrl:
                      'https://raw.githubusercontent.com/mrHeinrichh/J.E-Moral-cdn/main/assets/png/motorcycle-pin.png',
                ),
                anchorPos: AnchorPos.align(AnchorAlign.top),
              ),
              Marker(
                width: 70.0,
                height: 40.0,
                point: routePoints.isNotEmpty ? routePoints.last : LatLng(0, 0),
                builder: (ctx) => Container(
                  child: Icon(
                    Icons.person_pin_circle,
                    color: Colors.green,
                    size: 40.0,
                  ),
                ),
                anchorPos: AnchorPos.align(AnchorAlign.top),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> fetchData() async {
    if (!isLoading) {
      return;
    }

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

        setState(() {
          isLoading = false;
        });
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

  void parseWaypoints(Map<String, dynamic> routingData) {
    try {
      routePoints.clear(); // Clear existing points before adding new ones

      List<dynamic> segments =
          routingData['features'][0]['geometry']['coordinates'];

      for (var segment in segments) {
        List<LatLng> segmentPoints = [];
        for (var coordinate in segment) {
          double latitude = coordinate[1].toDouble();
          double longitude = coordinate[0].toDouble();
          segmentPoints.add(LatLng(latitude, longitude));
        }
        routePoints.addAll(segmentPoints);
      }

      // Only update the relevant parts of the UI
      setState(() {});
    } catch (e) {
      print('Error parsing waypoints: $e');
    }
  }
}

class CustomMarker extends StatelessWidget {
  final String iconUrl;

  CustomMarker({required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(iconUrl, width: 40.0, height: 40.0),
    );
  }
}

double calculateZoom(
    double minLat, double maxLat, double minLng, double maxLng) {
  const double paddingFactor = 1.1; // Adjust this to add padding around markers
  double latRange = (maxLat - minLat) * paddingFactor;
  double lngRange = (maxLng - minLng) * paddingFactor;

  double diagonal = math.sqrt(latRange * latRange + lngRange * lngRange);

  // 256 is the default tile size
  double zoom =
      (math.log(360.0 / 256.0 * (EarthRadius * math.pi) / diagonal) / math.ln2)
          .floorToDouble();

  return zoom;
}

const double EarthRadius = 150;
