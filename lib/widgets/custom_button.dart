import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;

  CustomButton({
    required this.onPressed,
    required this.text,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class CustomWhiteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  CustomWhiteButton({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            const Color.fromARGB(255, 255, 255, 255), // Background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF232937),
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class CustomizedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double height;
  final double width;
  final double fontz;
  final bool enabled; // Add the 'enabled' parameter

  CustomizedButton({
    required this.onPressed,
    required this.text,
    required this.height,
    required this.width,
    required this.fontz,
    this.enabled = true, // Provide a default value of true
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: height,
        width: width,
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null, // Use null if not enabled
          style: ElevatedButton.styleFrom(
            backgroundColor: enabled
                ? const Color(0xFF232937)
                : Colors.grey, // Use grey color if not enabled
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontz,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  ProfileButton({
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: text == 'Logout'
            ? Colors.red
            : Colors.black87, // Change the background color as needed
        elevation: 2, // Add elevation to the button
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Adjust the border radius as needed
        ),
      ),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
