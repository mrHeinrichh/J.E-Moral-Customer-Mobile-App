import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/view/login.page.dart';
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
  File? _image2;
  bool isPWDClicked = false;
  bool isLoading = false;
  final nameController = TextEditingController();
  final contactNumberController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
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

  Future<void> _pickImage2() async {
    final pickedFile2 =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile2 != null) {
      setState(() {
        _image2 = File(pickedFile2.path);
      });
    }
  }

  Future<void> signup() async {
    setState(() {
      isLoading = true;
    });

    if (isCheckboxChecked) {
      if (formKey.currentState!.validate()) {
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

        try {
          final responseImage1 = await uploadImageToServer(_image!);

          if (responseImage1 != null) {
            final imageUrl1 = responseImage1["data"][0]["path"];
            userData["image"] = imageUrl1;
          }
          if (_image2 != null) {
            final responseImage2 = await uploadImageToServer(_image2!);

            if (responseImage2 != null) {
              final imageUrl2 = responseImage2["data"][0]["path"];
              userData["discountIdImage"] = imageUrl2;
            }
          }

          final userResponse = await http.post(
            Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/users'),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(userData),
          );

          if (userResponse.statusCode == 200) {
            print("User created successfully.");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          } else {
            print("Response: ${userResponse.body}");
          }
        } catch (error) {
          print("Error during sign-up: $error");
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      }
    } else {
      setState(() {
        checkboxError = 'Please accept the Terms of Use & Privacy Policy';
        isLoading = false;
      });
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

      String fileExtension = imageFile.path.split('.').last.toLowerCase();
      var contentType = MediaType('image', 'png');

      Map<String, String> imageExtensions = {
        'png': 'png',
        'jpg': 'jpeg',
        'jpeg': 'jpeg',
        'gif': 'gif',
      };

      if (imageExtensions.containsKey(fileExtension)) {
        contentType = MediaType('image', imageExtensions[fileExtension]!);
      }

      var multipartFile = http.MultipartFile(
        'image',
        fileStream,
        length,
        filename: 'image.$fileExtension',
        contentType: contentType,
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 0.0),
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 50.0),
                      Column(
                        children: <Widget>[
                          const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Create an account, It's free",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          const Divider(),
                          const SizedBox(height: 10.0),
                          _image == null
                              ? const CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 50,
                                  backgroundImage: FileImage(_image!),
                                ),
                          TextButton(
                            onPressed: _pickImage,
                            child: const Text(
                              "Upload Image",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
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
                            decoration: const InputDecoration(
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
                            decoration: const InputDecoration(
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
                            decoration: const InputDecoration(
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
                            decoration: const InputDecoration(
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
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isPWDClicked = true;
                                  });
                                },
                                child: Text(
                                  "Are you a Person with Disability (PWD)?",
                                  style: TextStyle(
                                    color: isPWDClicked
                                        ? Colors.blue
                                        : Colors.black,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                              isPWDClicked
                                  ? (_image2 == null
                                      ? Container(
                                          width: 250,
                                          height: 100,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Colors.grey,
                                          ),
                                          child: const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                        )
                                      : Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: FileImage(_image2!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ))
                                  : Container(),
                              isPWDClicked
                                  ? TextButton(
                                      onPressed: _pickImage2,
                                      child: Text(
                                        "Upload your PWD ID",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Checkbox(
                                value: isCheckboxChecked,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    isCheckboxChecked = newValue ?? false;
                                    checkboxError = null;
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
                            backgroundColor: const Color(0xFF232937),
                            onPressed: () {
                              Navigator.pushNamed(context, onboardingRoute);
                            },
                            text: "Back",
                          ),
                          if (checkboxError != null)
                            Text(
                              checkboxError!,
                              style: const TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
