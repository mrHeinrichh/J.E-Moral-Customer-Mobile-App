import 'dart:convert';
import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/view/profile.page.dart';
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

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: 11, minute: 0),
      );

      if (pickedTime != null) {
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

  Future<void> _updateAppointment(BuildContext context) async {
    String? userId = Provider.of<UserProvider>(context, listen: false).userId;

    if (userId != null && selectedDate != null) {
      final apiUrl = 'https://lpg-api-06n8.onrender.com/api/v1/users/$userId';

      String formattedDateTime =
          DateFormat('yyyy-MM-dd HH:mm').format(selectedDate!);

      final patchData = {
        "appointmentDate": formattedDateTime,
        "appointmentStatus": "Pending",
        "__t": "Customer"
      };

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Appointment'),
            content: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "Selected Date and Time: \n",
                  ),
                  TextSpan(
                    text: selectedDate != null
                        ? DateFormat('MMM d, y - h:mm a').format(selectedDate!)
                        : "You haven't picked date and time yet.",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    final response = await http.patch(
                      Uri.parse(apiUrl),
                      headers: {
                        'Content-Type': 'application/json',
                      },
                      body: jsonEncode(patchData),
                    );

                    print(response.body);

                    if (response.statusCode == 200) {
                      print('Appointment updated successfully');

                      dateController.clear();

                      showCustomOverlay(context, 'Appointment confirmed!');

                      Navigator.pushNamed(context, dashboardRoute);
                    } else {
                      print(
                          'Failed to update appointment. Status code: ${response.statusCode}');
                    }
                  } catch (e) {
                    print('Error updating appointment: $e');
                  }
                },
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Invalid Time'),
            content: const Text(
                'Please select a time between store hours 7:00 AM and 7:00 PM.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
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
            'Applying for Delivery Driver',
            style: TextStyle(
              color: Color(0xFF232937),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(30, 30, 30, 5),
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
                      '- Biodata',
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      '- Drivers License (1 or 2 - Professional)',
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      '- Barangay/Police/NBI Clearance(if available)',
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      '- Fire Safety Certification',
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      '- Verified Gcash Account',
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
                      decoration: const InputDecoration(
                        labelText: 'Date and Time',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: CustomizedButton(
                    onPressed: () => _updateAppointment(context),
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
      ),
    );
  }
}

void showCustomOverlay(BuildContext context, String message) {
  final overlay = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height * 0.5,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            message,
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );

  Overlay.of(context)!.insert(overlay);

  Future.delayed(const Duration(seconds: 2), () {
    overlay.remove();
  });
}
