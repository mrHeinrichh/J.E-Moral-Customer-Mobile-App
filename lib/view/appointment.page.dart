import 'package:customer_app/widgets/custom_button.dart';
import 'package:customer_app/widgets/date_time_picker.dart';
import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DateTime? selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

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
        dateController.text = '${picked.toLocal()}'.split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        timeController.text = picked.format(context);
      });
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 60, 5, 5),
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
              DateTimePicker(
                dateController: dateController,
                timeController: timeController,
                onDateTap: () => _selectDate(context),
                onTimeTap: () => _selectTime(context),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: CustomizedButton(
                  onPressed: () {},
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
