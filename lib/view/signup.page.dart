import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:customer_app/widgets/privacy_policy_dialog.dart';
import 'package:customer_app/widgets/signup_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  File? _image;
  final nameController = TextEditingController();
  final contactNumberController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>(); // Form key
  bool isCheckboxChecked = false;
  String? checkboxError;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> signup() async {
    if (isCheckboxChecked) {
      if (formKey.currentState!.validate()) {
        // Your existing code to handle signup
      }
    } else {
      setState(() {
        checkboxError = 'Please accept the Terms of Use & Privacy Policy';
      });
    }
    if (formKey.currentState!.validate() && isCheckboxChecked) {
      final userData = {
        "name": nameController.text,
        "contactNumber": contactNumberController.text,
        "address": addressController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "hasAppointment": "false",
        "verified": "false",
        "discounted": "false",
        "type": "Customer",
        "discountIdImage": "",
        "dateInterview": "",
        "timeInterview": "",
        "image": "",
      };

      final response = await uploadImageToServer(_image!);

      if (response != null) {
        final imageUrl = response["data"][0]["path"];
        userData["image"] = imageUrl;
      }

      final userResponse = await http.post(
        Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/users'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      );

      if (userResponse.statusCode == 201) {
        print("User created successfully.");
      } else {
        print("Response: ${userResponse.body}");
      }
    }
  }

  Future<Map<String, dynamic>?> uploadImageToServer(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/upload/image'),
      );

      var fileStream = http.ByteStream(Stream.castFrom(imageFile.openRead()));
      var length = await imageFile.length();

      var multipartFile = http.MultipartFile(
        'image',
        fileStream,
        length,
        filename: 'image.png',
        contentType: MediaType('image', 'png'),
      );

      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final parsedResponse = json.decode(responseBody);
        return parsedResponse;
      } else {
        print("Image upload failed with status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Image upload failed with error: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40.0),
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Form(
              key: formKey, // Form widget with form key
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 50.0),
                  Column(
                    children: <Widget>[
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          hintText: "Enter your Full Name",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Full Name is required';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: contactNumberController,
                        decoration: InputDecoration(
                          labelText: "Contact Number",
                          hintText: "Enter your Contact Number",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Contact Number is required';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                          labelText: "Address",
                          hintText: "Enter your Address",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Address is required';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          hintText: "Enter your Email Address",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email Address is required';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your Password",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      _image == null
                          ? ElevatedButton(
                              onPressed: _pickImage,
                              child: Text("Choose Image"),
                            )
                          : Image.file(_image!, height: 100, width: 100),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: isCheckboxChecked,
                            onChanged: (bool? newValue) {
                              setState(() {
                                isCheckboxChecked = newValue ?? false;
                                checkboxError = null; // Clear the error message
                              });
                            },
                          ),
                          GestureDetector(
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
                        ],
                      ),
                      const SizedBox(height: 16),
                      SignupButton(
                        onPressed: signup,
                      ),
                      CustomButton(
                        backgroundColor: Color(0xFF232937),
                        onPressed: () {
                          Navigator.pushNamed(context, onboardingRoute);
                        },
                        text: "Back",
                      ),
                      if (checkboxError != null)
                        Text(
                          checkboxError!,
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
