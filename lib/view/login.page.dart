import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:customer_app/view/user_provider.dart';
import 'package:customer_app/widgets/login_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController =
      TextEditingController(text: 'customer@gmail.com');
  TextEditingController passwordController =
      TextEditingController(text: 'customer');

  Future<Map<String, dynamic>> login(String? email, String? password,
      [BuildContext? context]) async {
    if (email == null || password == null) {
      print('Email or password is null');
      return {'error': 'Invalid email or password'};
    }

    print('Email: $email, Password: $password');

    try {
      final response = await http.post(
        Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        print('Login Response: $data');

        if (data['status'] == 'success') {
          if (context != null) {
            final List<dynamic>? userData = data['data'];
            if (userData != null && userData.isNotEmpty) {
              // Accessing the correct nested values
              String userId = userData[0]['_doc']['user'] ?? '';

              print('User ID: $userId');

              // Fetch additional user details using the user ID
              final userDetailsResponse = await http.get(
                Uri.parse(
                    'https://lpg-api-06n8.onrender.com/api/v1/users/$userId'),
                headers: {
                  'Content-Type': 'application/json',
                },
              );

              print('User Details Response: ${userDetailsResponse.statusCode}');

              if (userDetailsResponse.statusCode == 200) {
                final Map<String, dynamic> userDetailsData =
                    jsonDecode(userDetailsResponse.body);

                print('User Details: $userDetailsData');

                // Extract "type" field from user details
                String userType = userDetailsData['data']['__t'] ?? '';

                print('User Type: $userType');

                if (userType == 'Customer') {
                  // Check if the user is verified
                  bool isVerified =
                      userDetailsData['data']['verified'] ?? false;

                  if (isVerified != null) {
                    if (isVerified) {
                      // Set the user ID in the app state
                      Provider.of<UserProvider>(context, listen: false)
                          .setUserId(userId);
                      return data;
                    } else {
                      return {'error': 'User is not verified'};
                    }
                  } else {
                    return {'error': 'Verification status not available'};
                  }
                } else {
                  return {'error': 'Invalid user type'};
                }
              } else {
                print(
                    'Failed to fetch user details. Response code: ${userDetailsResponse.statusCode}');
                return {'error': 'Failed to fetch user details'};
              }
            } else {
              return {'error': 'User data is missing or empty'};
            }
          }

          return data;
        } else {
          return {'error': 'Login failed'};
        }
      } else {
        print('Login failed. Response code: ${response.statusCode}');
        return {'error': 'Login failed'};
      }
    } catch (error, stackTrace) {
      print('Error: $error');
      print('Stack trace: $stackTrace');
      return {'error': 'An error occurred during login'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 60.0),
                Image.network(
                  'https://raw.githubusercontent.com/mrHeinrichh/J.E-Moral-cdn/main/assets/png/logo-main.png',
                  width: 550.0,
                  height: null,
                ),
                const SizedBox(height: 50.0),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    hintText: "Enter your Email Address",
                  ),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your Password",
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text("Forgot your password?")],
                ),
                SizedBox(height: 30.0),
                Column(
                  children: [
                    LoginButton(
                      onPressed: () async {
                        final loginResult = await login(
                          emailController.text,
                          passwordController.text,
                          context,
                        );

                        print('Login Result: $loginResult');

                        if (loginResult.containsKey('error')) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Login Failed'),
                                content: Text(loginResult['error']),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Navigator.pushNamed(context, dashboardRoute);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    CustomWhiteButton(
                      onPressed: () {
                        Navigator.pushNamed(context, onboardingRoute);
                      },
                      text: "Back",
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
