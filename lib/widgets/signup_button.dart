import 'package:flutter/material.dart';

class SignupButton extends StatelessWidget {
  final VoidCallback onPressed;

  SignupButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // Background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: const Text(
            "Signup",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
