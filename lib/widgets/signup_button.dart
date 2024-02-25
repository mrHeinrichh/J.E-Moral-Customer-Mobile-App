import 'package:flutter/material.dart';

class SignupButton extends StatelessWidget {
  final VoidCallback onPressed;

  SignupButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            "Create an Account",
            style: TextStyle(
              color: const Color(0xFF050404).withOpacity(0.9),
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class SignupBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  SignupBackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: const Text(
            "Back",
            style: TextStyle(
              color: Color(0xFF050404),
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
