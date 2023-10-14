import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:customer_app/widgets/custom_timepicker.dart';
import 'package:customer_app/widgets/location_button.dart';
import 'package:customer_app/widgets/location_search.dart';
import 'package:customer_app/widgets/text_field.dart';

class SetDeliveryPage extends StatefulWidget {
  @override
  _SetDeliveryPageState createState() => _SetDeliveryPageState();
}

DateTime? selectedDateTime;

enum PaymentMethod { cashOnDelivery, gcashPayment }

enum AssemblyOption { yes, no }

class _SetDeliveryPageState extends State<SetDeliveryPage> {
  String? selectedLocation;
  PaymentMethod? selectedPaymentMethod;
  AssemblyOption? selectedAssemblyOption;
  List<String> searchResults = [];
  TextEditingController locationController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController houseNumberController = TextEditingController();

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

  // Function to show a modal dialog with inputted data
  Future<void> showConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delivery Location: ${locationController.text}'),
              Text('Name: ${nameController.text}'),
              Text('Contact Number: ${contactNumberController.text}'),
              Text('House#/Lot/Blk: ${houseNumberController.text}'),
              Text('Scheduled Date and Time: ${selectedDateTime.toString()}'),
              Text('Payment Method: ${selectedPaymentMethod.toString()}'),
              Text(
                  'Needs to be assembled: ${selectedAssemblyOption.toString()}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform the confirmation action here
                // You can send the data to your server or perform any other action.
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
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
                CustomTextField1(
                  labelText: 'Name',
                  hintText: 'Enter your Name',
                  controller: nameController,
                ),
                CustomTextField1(
                  labelText: 'Contact Number',
                  hintText: 'Enter your contact number',
                  controller: contactNumberController,
                ),
                CustomTextField1(
                  labelText: 'House#/Lot/Blk',
                  hintText: 'Enter your house number',
                  controller: houseNumberController,
                ),
                const SizedBox(height: 20),
                const Text("Choose Payment Method"),
                ListTile(
                  title: const Text('Cash On Delivery'),
                  leading: Radio<PaymentMethod>(
                    value: PaymentMethod.cashOnDelivery,
                    groupValue: selectedPaymentMethod,
                    onChanged: (PaymentMethod? value) {
                      setState(() {
                        selectedPaymentMethod = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Gcash Payment'),
                  leading: Radio<PaymentMethod>(
                    value: PaymentMethod.gcashPayment,
                    groupValue: selectedPaymentMethod,
                    onChanged: (PaymentMethod? value) {
                      setState(() {
                        selectedPaymentMethod = value;
                      });
                    },
                  ),
                ),
                Text("Needs to be assembled?"),
                ListTile(
                  title: const Text('Yes'),
                  leading: Radio<AssemblyOption>(
                    value: AssemblyOption.yes,
                    groupValue: selectedAssemblyOption,
                    onChanged: (AssemblyOption? value) {
                      setState(() {
                        selectedAssemblyOption = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('No'),
                  leading: Radio<AssemblyOption>(
                    value: AssemblyOption.no,
                    groupValue: selectedAssemblyOption,
                    onChanged: (AssemblyOption? value) {
                      setState(() {
                        selectedAssemblyOption = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomizedButton(
                onPressed: () async {
                  final selectedDate = await showDateTimePicker(context);
                  if (selectedDate != null) {
                    setState(() {
                      selectedDateTime = selectedDate;
                      // Show the confirmation dialog when a date is selected
                      showConfirmationDialog();
                    });
                  }
                },
                text: 'Scheduled',
                height: 50,
                width: 180,
                fontz: 20,
              ),
              CustomizedButton(
                onPressed: () {
                  showConfirmationDialog();
                },
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
