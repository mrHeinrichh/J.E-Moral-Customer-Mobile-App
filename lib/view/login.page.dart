import 'package:customer_app/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController =
      TextEditingController(text: 'customer@gmail.com');
  TextEditingController passwordController =
      TextEditingController(text: 'customer');

  Future<Map<String, dynamic>> login(String email, String password) async {
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

      if (data['status'] == 'success') {
        return data;
      } else {
        return {'error': 'Login failed'};
      }
    } else {
      return {'error': 'Login failed'};
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
                            emailController.text, passwordController.text);

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
