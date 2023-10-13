import 'package:customer_app/widgets/location_button.dart';
import 'package:customer_app/widgets/location_search.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:customer_app/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SetDeliveryPage extends StatefulWidget {
  @override
  _SetDeliveryPageState createState() => _SetDeliveryPageState();
}

enum PaymentMethod { cashOnDelivery, gcashPayment }

enum AssemblyOption { yes, no }

class _SetDeliveryPageState extends State<SetDeliveryPage> {
  String? selectedLocation;
  PaymentMethod? selectedPaymentMethod;
  AssemblyOption? selectedAssemblyOption;
  List<String> searchResults = [];
  TextEditingController locationController = TextEditingController();

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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'History',
          style: TextStyle(color: Color(0xFF232937), fontSize: 24),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const Text(
                  "Set Delivery Location",
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    children: [
                      LocationSearchWidget(
                        locationController: locationController,
                        onLocationChanged: (query) {
                          fetchLocationData(query);
                        },
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(searchResults[index]),
                            onTap: () {
                              setState(() {
                                selectedLocation = searchResults[index];
                                locationController.text = searchResults[index];
                                searchResults = [];
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                LocationButtonWidget(
                  onLocationChanged: (String address) {
                    locationController.text = address;
                  },
                ),
                const CustomTextField1(
                  labelText: 'Name',
                  hintText: 'Enter your Name',
                ),
                const CustomTextField1(
                  labelText: 'Contact Number',
                  hintText: 'Enter your contact number',
                ),
                const CustomTextField1(
                  labelText: 'House#/Lot/Blk',
                  hintText: 'Enter your house number',
                ),
                const SizedBox(height: 20),
                const Text("Choose Payment Method"),
                // Radio buttons and other UI elements
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomizedButton(
                onPressed: () {},
                text: 'Scheduled',
                height: 50,
                width: 180,
                fontz: 20,
              ),
              CustomizedButton(
                onPressed: () {},
                text: 'Deliver Now',
                height: 50,
                width: 180,
                fontz: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
