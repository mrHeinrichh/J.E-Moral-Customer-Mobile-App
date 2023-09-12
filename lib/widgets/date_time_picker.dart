import 'package:flutter/material.dart';

class DateTimePicker extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController timeController;
  final Function() onDateTap;
  final Function() onTimeTap;

  DateTimePicker({
    required this.dateController,
    required this.timeController,
    required this.onDateTap,
    required this.onTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: dateController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Selected Date',
            border: OutlineInputBorder(),
          ),
          onTap: onDateTap,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: timeController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Selected Time',
            border: OutlineInputBorder(),
          ),
          onTap: onTimeTap,
        ),
      ],
    );
  }
}
