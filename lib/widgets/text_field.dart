import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final double borderRadius;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.borderRadius = 10,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        cursorColor: const Color(0xFF050404),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color(0xFF050404).withOpacity(0.6),
          ),
          labelStyle: TextStyle(
            color: const Color(0xFF050404).withOpacity(0.7),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF050404)),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF050404)),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        validator: validator,
      ),
    );
  }
}

class FeedbackTextField extends StatelessWidget {
  final double borderRadius;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const FeedbackTextField({
    Key? key,
    this.borderRadius = 10,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      cursorColor: const Color(0xFF050404),
      controller: controller,
      decoration: InputDecoration(
        labelStyle: TextStyle(
          fontSize: 14,
          color: const Color(0xFF050404).withOpacity(0.7),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF050404)),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF050404)),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      validator: validator,
    );
  }
}
