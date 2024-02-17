import 'dart:convert';
import 'package:customer_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:customer_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:customer_app/view/user_provider.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DateTime? selectedDate = DateTime.now();
  String? appointmentStatus;

  TextEditingController dateController = TextEditingController();

  // Future<void> _selectDateTime(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(DateTime.now().year + 1),
  //   );

  //   if (pickedDate != null) {
  //     final TimeOfDay? pickedTime = await showTimePicker(
  //       context: context,
  //       initialTime: TimeOfDay.now(),
  //     );

  //     if (pickedTime != null) {
  //       final selectedDateTime = DateTime(
  //         pickedDate.year,
  //         pickedDate.month,
  //         pickedDate.day,
  //         pickedTime.hour,
  //         pickedTime.minute,
  //       );

  //       setState(() {
  //         selectedDate = selectedDateTime;
  //         dateController.text =
  //             DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);
  //       });
  //     }
  //   }
  // }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: 11, minute: 0), // Set initial time to 11:00 AM
      );

      if (pickedTime != null) {
        // Check if the picked time is between 11 AM and 3 PM
        if (pickedTime.hour >= 7 && pickedTime.hour < 19) {
          final selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          setState(() {
            selectedDate = selectedDateTime;
            dateController.text =
                DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);
          });
        } else {
          // Clear the previous value in the text box
          dateController.clear();

          // Notify the user that the selected time is not allowed
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Invalid Time'),
                content: Text(
                    'Please select a time between store hours 7:00 AM and 7:00 PM.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
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

  // Future<void> _updateAppointment() async {
  //   String? userId = Provider.of<UserProvider>(context, listen: false).userId;

  //   if (userId != null && selectedDate != null) {
  //     final apiUrl = 'https://lpg-api-06n8.onrender.com/api/v1/users/$userId';

  //     // Format the selected date to the desired format
  //     String formattedDate = '${selectedDate!.toLocal()}'.split(' ')[0];

  //     final patchData = {
  //       "appointmentDate": formattedDate,
  //       "appointmentStatus": "Pending",
  //       "type": "Customer"
  //     };

  //     print('Request body: ${jsonEncode(patchData)}'); // Log the request body

  //     try {
  //       final response = await http.patch(
  //         Uri.parse(apiUrl),
  //         headers: {
  //           'Content-Type': 'application/json',
  //         },
  //         body: jsonEncode(patchData),
  //       );

  //       print('Response body: ${response.body}'); // Log the response body

  //       if (response.statusCode == 200) {
  //         print(response.statusCode);
  //         print('Appointment updated successfully');
  //         Navigator.pushNamed(context, dashboardRoute);
  //       } else {
  //         print(
  //             'Failed to update appointment. Status code: ${response.statusCode}');
  //       }
  //     } catch (e) {
  //       print('Error updating appointment: $e');
  //     }
  //   }
  // }
  Future<void> _updateAppointment(BuildContext context) async {
    String? userId = Provider.of<UserProvider>(context, listen: false).userId;

    if (userId != null && selectedDate != null) {
      final apiUrl = 'https://lpg-api-06n8.onrender.com/api/v1/users/$userId';

      // Format the selected date to the desired format
      String formattedDateTime =
          DateFormat('yyyy-MM-dd HH:mm').format(selectedDate!);

      // Define the patch data
      final patchData = {
        "appointmentDate": formattedDateTime, // Include both date and time
        "appointmentStatus": "Pending",
        "type": "Customer"
      };

      // Create the confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Appointment'),
            content: Text('Selected Date and Time:\n$formattedDateTime'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // Proceed with setting the appointment
                  try {
                    final response = await http.patch(
                      Uri.parse(apiUrl),
                      headers: {
                        'Content-Type': 'application/json',
                      },
                      body: jsonEncode(patchData),
                    );

                    if (response.statusCode == 200) {
                      print(response.statusCode);
                      print('Appointment updated successfully');
                      Navigator.of(context).pop(); // Close the dialog
                      dateController.clear();

                      // Display a message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Appointment confirmed!'),
                        ),
                      );
                      // You can redirect to the same page if needed
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (_) => YourWidget()),
                      // );
                    } else {
                      print(
                          'Failed to update appointment. Status code: ${response.statusCode}');
                    }
                  } catch (e) {
                    print('Error updating appointment: $e');
                  }
                },
                child: Text('Confirm'),
              ),
            ],
          );
        },
      );
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
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            'Applying for a Delivery Driver?',
            style: TextStyle(color: Color(0xFF232937), fontSize: 24),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30,
                5), // Adjust the left and right padding values as needed
            child: Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Greetings user! We appreciate clicking this section and showing your interest in applying as delivery driver. Few reminders, your submission of requirements do not actually mean that you are already accepted. You are still subject to interview based on your appointment date. To expect fast transaction once your application is accepted, prepare the following requirements below: ',
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '-Biodata',
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    '-Drivers License (1 or 2 - Professional)',
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    '-Barangay/Police/NBI Clearance(if available)',
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    '-Fire Safety Certification',
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    '-Verified Gcash Account',
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Note: You are required to undergo seminar once hired. Other details will be provided during the interview.',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(children: [
              GestureDetector(
                onTap: () => _selectDateTime(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Date and Time',
                      hintText: 'Select date',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: CustomizedButton(
                  onPressed: () => _updateAppointment(
                      context), // Pass the context to _updateAppointment
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
