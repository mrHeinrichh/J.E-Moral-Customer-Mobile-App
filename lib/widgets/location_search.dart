import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationSearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onLocationChanged;
  final String labelText;
  final String hintText;
  final double borderRadius;
  final String? Function(String?)? validator;
  final Widget? child;

  LocationSearchWidget({
    required this.controller,
    required this.onLocationChanged,
    required this.labelText,
    required this.hintText,
    this.borderRadius = 10,
    this.validator,
    this.child,
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
        TextFormField(
          controller: widget.controller,
          cursorColor: const Color(0xFF050404),
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: const Color(0xFF050404).withOpacity(0.6),
            ),
            labelStyle: TextStyle(
              color: const Color(0xFF050404).withOpacity(0.7),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF050404)),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF050404)),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
          onChanged: widget.onLocationChanged,
          validator: widget.validator,
        ),
        if (widget.child != null) widget.child!,
        ListView.builder(
          shrinkWrap: true,
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(searchResults[index]),
              onTap: () {
                setState(() {
                  widget.controller.text = searchResults[index];
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
