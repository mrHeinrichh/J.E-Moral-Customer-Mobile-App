import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:customer_app/widgets/privacy_policy_dialog.dart';
import 'package:customer_app/widgets/signup_button.dart';
import 'package:customer_app/widgets/text_field.dart';
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
  File? _image; // This will hold the selected image file.
  // final nameController = TextEditingController();
  // final contactNumberController = TextEditingController();
  // final addressController = TextEditingController();
  // final emailController = TextEditingController();
  // final passwordController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Call your image upload function here
      final response = await uploadImageToServer(_image!);

      if (response != null) {
        print("Image uploaded successfully.");
        print("Response: $response");
      } else {
        print("Image upload failed.");
      }
    }
  }

  Future<void> signup() async {
    // Implement your signup logic here and use the response from image upload if needed.
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
  void dispose() {
    // Dispose of the controllers to free resources
    // nameController.dispose();
    // contactNumberController.dispose();
    // addressController.dispose();
    // emailController.dispose();
    // passwordController.dispose();
    super.dispose();
  }

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
                    // CustomTextField1(
                    //   labelText: "Full Name",
                    //   hintText: "Enter your Full Name",
                    //   borderRadius: 40.0,
                    //   controller: nameController,
                    // ),
                    // CustomTextField1(
                    //   labelText: "Contact Number",
                    //   hintText: "Enter your Contact Number",
                    //   borderRadius: 40.0,
                    //   controller: contactNumberController,
                    // ),
                    // CustomTextField1(
                    //   labelText: "address",
                    //   hintText: "Enter your address",
                    //   borderRadius: 40.0,
                    //   controller: addressController,
                    // ),
                    // CustomTextField1(
                    //   labelText: "Email Address",
                    //   hintText: "Enter your Email Address",
                    //   borderRadius: 40.0,
                    //   controller: emailController,
                    // ),
                    // CustomTextField1(
                    //   labelText: "Password",
                    //   hintText: "Enter your Password",
                    //   borderRadius: 40.0,
                    //   controller: passwordController,
                    // ),
                    _image == null
                        ? ElevatedButton(
                            onPressed: _pickImage,
                            child: Text("Choose Image"),
                          )
                        : Image.file(_image!, height: 100, width: 100),
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
                      onPressed: signup,
                    ),
                    CustomButton(
                      backgroundColor: Color(0xFF232937),
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
