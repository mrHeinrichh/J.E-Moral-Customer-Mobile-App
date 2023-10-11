import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 4.0), // Set your desired margin here
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(fontSize: 15.0),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
      ),
    );
  }
}

class CustomTextField1 extends StatelessWidget {
  final String labelText;
  final String hintText;
  final double borderRadius; // Add a new parameter for border radius

  const CustomTextField1({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.borderRadius = 10.0, // Default border radius is 40.0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(fontSize: 15.0),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
