import 'package:flutter/material.dart';

class PrivacyPolicyDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "DATA PRIVACY ACT OF 2012",
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Column(
        children: [
          Text(
            "By signing up to this system, you are agreeing to the following terms:",
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          Text(
            "We will collect your personal information, including your name, email address, and any other information you provide to us",
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          Text(
            "We will not share your personal information with third parties without your consent",
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          Text(
            "Administrators have the right to edit your personal information, upon your consent",
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          Spacer(),
          Text(
            "You can withdraw your consent to our use of your personal information at any time",
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          Spacer(),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
      ],
    );
  }
}
