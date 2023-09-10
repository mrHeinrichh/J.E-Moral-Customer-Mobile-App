import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:customer_app/widgets/privacy_policy_dialog.dart';
import 'package:customer_app/widgets/signup_button.dart';
import 'package:customer_app/widgets/text_field.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40.0),
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 50.0),
                Column(
                  children: <Widget>[
                    const CustomTextField(
                      labelText: "Full Name",
                      hintText: "Enter your Full Name",
                    ),
                    const CustomTextField(
                      labelText: "Email Address",
                      hintText: "Enter your Email Address",
                    ),
                    const CustomTextField(
                      labelText: "Full Address",
                      hintText: "Enter your Full Address",
                    ),
                    const CustomTextField(
                      labelText: "Contact Number",
                      hintText: "Enter your Contact Number",
                    ),
                    const CustomTextField(
                      labelText: "Password",
                      hintText: "Enter your Password",
                    ),
                    const CustomTextField(
                      labelText: "Confirm Password",
                      hintText: "Confirm your Password",
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: false,
                          onChanged: (bool? newValue) {},
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return PrivacyPolicyDialog();
                                },
                              );
                            },
                            child: const Text(
                              "I accept the Terms of Use & Privacy Policy",
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SignupButton(
                      onPressed: () {},
                    ),
                    CustomButton(
                      onPressed: () {
                        Navigator.pushNamed(context, onboardingRoute);
                      },
                      text: "Back",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
