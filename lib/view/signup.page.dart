import 'dart:async';

import 'package:customer_app/routes/app_routes.dart';
import 'package:customer_app/view/login.page.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:customer_app/widgets/custom_image_upload.dart';
import 'package:customer_app/widgets/privacy_policy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool isLoading = false;
  final nameController = TextEditingController();
  final contactNumberController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isCheckboxChecked = false;
  String? checkboxError;
  bool isImageSelected = false;
  final _imageStreamController = StreamController<File?>.broadcast();

  Future<void> _takeImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path); //
      _imageStreamController.sink.add(imageFile); //
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path); //
      _imageStreamController.sink.add(imageFile); //
      setState(() {
        _image = File(pickedFile.path);
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

  Future<void> signup() async {
    if (!isImageSelected) {
      showCustomOverlay(context, 'Please Upload a Profile Image');
    } else if (formKey.currentState!.validate()) {
      if (formKey.currentState!.validate()) {
        if (isCheckboxChecked) {
          setState(() {
            isLoading = true;
          });
          final userData = {
            "name": nameController.text,
            "contactNumber": contactNumberController.text,
            "address": addressController.text,
            "email": emailController.text,
            "password": passwordController.text,
            "verified": false,
            "__t": "Customer",
            "image": "",
          };

          try {
            final responseImage1 = await uploadImageToServer(_image!);

            if (responseImage1 != null) {
              final imageUrl1 = responseImage1["data"][0]["path"];
              userData["image"] = imageUrl1;
            }

            final userResponse = await http.post(
              Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/users'),
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
              body: jsonEncode(userData),
            );

            print(userResponse.body);

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
                          // _image == null
                          //     ? const CircleAvatar(
                          //         radius: 50,
                          //         backgroundColor: Colors.grey,
                          //         child: Icon(
                          //           Icons.person,
                          //           color: Colors.white,
                          //           size: 50,
                          //         ),
                          //       )
                          //     : CircleAvatar(
                          //         radius: 50,
                          //         backgroundImage: FileImage(_image!),
                          //       ),
                          // TextButton(
                          //   onPressed: _pickImage,
                          //   child: const Text(
                          //     "Upload Image",
                          //     style: TextStyle(
                          //       color: Colors.blue,
                          //       fontSize: 15.0,
                          //     ),
                          //   ),
                          // ),
                          StreamBuilder<File?>(
                            stream: _imageStreamController.stream,
                            builder: (context, snapshot) {
                              return Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage: snapshot.data != null
                                            ? FileImage(snapshot.data!)
                                            : null,
                                        backgroundColor: Colors.grey,
                                        child: snapshot.data == null
                                            ? const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 50,
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                  ImageUploaderValidator(
                                    takeImage: _takeImage,
                                    pickImage: _pickImage,
                                    buttonText: "Upload Profile Image",
                                    onImageSelected: (isSelected) {
                                      setState(() {
                                        isImageSelected = isSelected;
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          TextFormField(
                            controller: nameController,
                            decoration:
                                const InputDecoration(labelText: 'Full Name'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Name";
                              } else {
                                return null;
                              }
                            },
                          ),
                          TextFormField(
                            controller: contactNumberController,
                            decoration: const InputDecoration(
                                labelText: 'Contact Number'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Number";
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          TextFormField(
                            controller: addressController,
                            decoration:
                                const InputDecoration(labelText: 'Address'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Address";
                              } else {
                                return null;
                              }
                            },
                          ),
                          TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                  labelText: 'Email Address'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter Email Address";
                                } else if (!RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                                    .hasMatch(value!)) {
                                  return "Enter Correct Email Address";
                                } else {
                                  return null;
                                }
                              }),
                          TextFormField(
                            controller: passwordController,
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter Password";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 10),
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
                              Flexible(
                                fit: FlexFit.loose,
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
                                      fontSize: 14.0,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (checkboxError != null)
                            Text(
                              checkboxError!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          const SizedBox(height: 16),
                          CustomButton(
                            backgroundColor: const Color(0xFF232937),
                            text: "Signup",
                            onPressed: signup,
                          ),
                          const SizedBox(height: 16),
                          CustomWhiteButton(
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
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

void showCustomOverlay(BuildContext context, String message) {
  final overlay = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height * 0.5,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );

  Overlay.of(context)!.insert(overlay);

  Future.delayed(const Duration(seconds: 2), () {
    overlay.remove();
  });
}
