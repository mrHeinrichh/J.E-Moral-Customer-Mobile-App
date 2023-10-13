import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationSearchWidget extends StatefulWidget {
  final TextEditingController locationController;
  final Function(String) onLocationChanged;

  LocationSearchWidget({
    required this.locationController,
    required this.onLocationChanged,
  });

  @override
  _LocationSearchWidgetState createState() => _LocationSearchWidgetState();
}

class _LocationSearchWidgetState extends State<LocationSearchWidget> {
  List<String> searchResults = [];

  Future<void> fetchLocationData(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }
    const apiKey = 'e8d77b2d8e7740c3b7727970dc8fc59e';
    final apiUrl =
        'https://api.geoapify.com/v1/geocode/autocomplete?text=$query&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('features')) {
          final features = data['features'] as List<dynamic>;
          final results = features
              .map((feature) => feature['properties']['formatted'] as String)
              .toList();

          setState(() {
            searchResults = results;
          });
        } else {
          print('No "features" key in the API response.');
        }
      } else {
        print('API Request Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.locationController,
          onChanged: widget.onLocationChanged,
          decoration: const InputDecoration(
            hintText: "Type a Location",
            border: InputBorder.none,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(searchResults[index]),
              onTap: () {
                setState(() {
                  widget.locationController.text = searchResults[index];
                  searchResults = [];
                });
              },
            );
          },
        ),
      ],
    );
  }
}
