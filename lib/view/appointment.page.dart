import 'dart:convert';
import 'package:customer_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:customer_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:customer_app/view/user_provider.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DateTime? selectedDate = DateTime.now();

  TextEditingController dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // Format the selected date
        dateController.text = '${picked.toLocal()}'.split(' ')[0];
      });
    }
  }

  Future<void> _fetchUserById() async {
    String? userId = Provider.of<UserProvider>(context, listen: false).userId;

    if (userId != null) {
      final apiUrl = 'https://lpg-api-06n8.onrender.com/api/v1/users/$userId';

      try {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          print('User details fetched successfully');
          print('Response body: ${response.body}');
        } else {
          print(
              'Failed to fetch user details. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching user details: $e');
      }
    }
  }

  Future<void> _updateAppointment() async {
    String? userId = Provider.of<UserProvider>(context, listen: false).userId;

    if (userId != null && selectedDate != null) {
      final apiUrl = 'https://lpg-api-06n8.onrender.com/api/v1/users/$userId';

      // Format the selected date to the desired format
      String formattedDate = '${selectedDate!.toLocal()}'.split(' ')[0];

      final patchData = {
        "appointmentDate": formattedDate,
        "appointmentStatus": "Pending",
        "type": "Customer"
      };

      print('Request body: ${jsonEncode(patchData)}'); // Log the request body

      try {
        final response = await http.patch(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(patchData),
        );

        print('Response body: ${response.body}'); // Log the response body

        if (response.statusCode == 200) {
          print(response.statusCode);
          print('Appointment updated successfully');
          Navigator.pushNamed(context, dashboardRoute);
        } else {
          print(
              'Failed to update appointment. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error updating appointment: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Call the fetch user method when the page is loaded
    _fetchUserById();
  }

  @override
  Widget build(BuildContext context) {
    String? userId = Provider.of<UserProvider>(context).userId;

    print('UserId in build method: $userId');

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(
            'Applying for a Rider',
            style: TextStyle(color: Color(0xFF232937), fontSize: 24),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 60, 5, 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Must have...',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Text(
                  '*BioData',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '*Drivers License ',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '*NBI Clearance(if available) ',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '*Fire Safety Certification ',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '*Verified Maya/Gcash ',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(children: [
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      hintText: 'Select date',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: CustomizedButton(
                  onPressed: _updateAppointment,
                  text: 'Book an Appointment',
                  height: 60,
                  width: 90,
                  fontz: 20,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
