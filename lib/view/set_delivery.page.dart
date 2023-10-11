import 'package:customer_app/widgets/custom_button.dart';
import 'package:customer_app/widgets/text_field.dart';
import 'package:flutter/material.dart';

enum DeliveryType { standard, express } // Define enum for delivery type

class SetDeliveryPage extends StatefulWidget {
  @override
  _SetDeliveryPageState createState() => _SetDeliveryPageState();
}

class _SetDeliveryPageState extends State<SetDeliveryPage> {
  String? selectedLocation;
  DeliveryType? selectedDeliveryType; // Store selected delivery type

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
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Set Delivery Location",
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedLocation,
                onChanged: (newValue) {
                  setState(() {
                    selectedLocation = newValue;
                  });
                },
                items: <String?>[
                  'Location 1',
                  'Location 2',
                  'Location 3',
                  'Location 4',
                  'Location 5',
                ].map<DropdownMenuItem<String>>((String? value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value ?? ''),
                  );
                }).toList(),
                decoration: InputDecoration(
                  hintText: "Select a Location",
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9), // Background color D9D9D9
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextButton(
                onPressed: () {
                  // Add your action when the button is pressed
                },
                child: Text(
                  "Use my current location",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            CustomTextField1(
              labelText: 'Name',
              hintText: 'Enter your Name',
            ),
            CustomTextField1(
              labelText: 'Contact Number',
              hintText: 'Enter your contact number',
            ),
            CustomTextField1(
              labelText: 'House#/Lot/Blk',
              hintText: 'Enter your house number',
            ),
            SizedBox(height: 20),
            // Add radio buttons for delivery type
            Text("Choose Payment Method"),
            ListTile(
              title: const Text('Cash On Delivery'),
              leading: Radio<DeliveryType>(
                value: DeliveryType.standard,
                groupValue: selectedDeliveryType,
                onChanged: (DeliveryType? value) {
                  setState(() {
                    selectedDeliveryType = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Gcash Payment'),
              leading: Radio<DeliveryType>(
                value: DeliveryType.express,
                groupValue: selectedDeliveryType,
                onChanged: (DeliveryType? value) {
                  setState(() {
                    selectedDeliveryType = value;
                  });
                },
              ),
            ),
            Text("Needs to be assembled?"),
            ListTile(
              title: const Text('Yes'),
              leading: Radio<DeliveryType>(
                value: DeliveryType.standard,
                groupValue: selectedDeliveryType,
                onChanged: (DeliveryType? value) {
                  setState(() {
                    selectedDeliveryType = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('No'),
              leading: Radio<DeliveryType>(
                value: DeliveryType.express,
                groupValue: selectedDeliveryType,
                onChanged: (DeliveryType? value) {
                  setState(() {
                    selectedDeliveryType = value;
                  });
                },
              ),
            ),
            CustomizedButton(
              onPressed: () {},
              text: 'Scheduled',
              height: 60,
              width: 260,
              fontz: 20,
            ),
            CustomizedButton(
              onPressed: () {},
              text: 'Deliver Now',
              height: 60,
              width: 260,
              fontz: 20,
            ),
          ],
        ),
      ),
    );
  }
}
