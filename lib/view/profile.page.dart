import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:customer_app/view/user_provider.dart';

import 'package:http_parser/http_parser.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _userDetailsFuture;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Automatically upload the selected image
      await _uploadSelectedImage();
    }

    print(_image);
  }

  Future<void> _uploadSelectedImage() async {
    if (_image != null) {
      final serverResponse = await uploadImageToServer(_image!);

      if (serverResponse != null) {
        // Handle the response as needed
        print('Image uploaded to server successfully');
        print(serverResponse);
      } else {
        print('Image upload to server failed');
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

  Future<void> updateUserProfile(String userId, String name,
      String contactNumber, String address, String email) async {
    try {
      final userData = await fetchUserDetails(userId);

      if (_image != null) {
        final serverResponse = await uploadImageToServer(_image!);

        if (serverResponse != null) {
          final imageUrl = serverResponse['data'][0]['path'];
          userData["image"] = imageUrl;
        }
      }

      final response = await http.patch(
        Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'image': userData["image"],
          'name': name,
          'contactNumber': contactNumber,
          'type': "Customer",
          'address': address,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        print('User updated successfully');
        print('Response.statusCode: ${response.statusCode}');
        print(response.body);

        setState(() {});
      } else {
        print('Failed to update user details: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      print('Error updating user details: $error');
    }
  }

  Future<Map<String, dynamic>> fetchUserDetails(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userDetails = jsonDecode(response.body);
        print(response.body);
        return userDetails;
      } else {
        throw Exception('Failed to load user details');
      }
    } catch (error) {
      print('Error fetching user details: $error');
      throw Exception('Failed to load user details');
    }
  }

  Future<void> changePassword(String userId, String newPassword) async {
    try {
      final response = await Dio().patch(
        'https://lpg-api-06n8.onrender.com/api/v1/users/$userId',
        data: {
          'password': newPassword,
        },
      );

      if (response.statusCode == 200) {
        print('Password changed successfully');
        print(response.data);
      } else {
        print('Failed to change password: ${response.statusCode}');
        print(response.data);
      }
    } catch (error) {
      print('Error changing password: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    String? userId = Provider.of<UserProvider>(context, listen: false).userId;
    _userDetailsFuture = fetchUserDetails(userId!);
    print(userId);
  }

  Widget buildProfileWidget(Map<String, dynamic> userDetails, String? userId) {
    final userData = userDetails['data'][0];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(
            'Profile',
            style: TextStyle(color: Color(0xFF232937), fontSize: 24),
          ),
        ),
        actions: [
          // Add a popup menu button with three dots
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Color(0xFF232937)),
            onSelected: (String result) {
              // Handle the selected option here
              if (result == 'logout') {
                Navigator.pushNamed(context,
                    '/login'); // Replace '/login' with your actual login route
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  child: Text('Log out'),
                  value: 'logout',
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Card(
            color: const Color(0xFF232937),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Registered Customer',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: userData['image'] != null
                      ? NetworkImage(userData['image']!)
                      : null,
                ),
                Text(
                  'Name: ${userData['name']}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Contact Number: ${userData['contactNumber']}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Address: ${userData['address']}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Email: ${userData['email']}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            _nameController.text = userData['name'] ?? '';
                            _contactNumberController.text =
                                userData['contactNumber'] ?? '';
                            _addressController.text = userData['address'] ?? '';
                            _emailController.text = userData['email'] ?? '';
                            return AlertDialog(
                              title: Text('Edit your profile Data'),
                              content: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
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
                                                backgroundImage:
                                                    FileImage(_image!),
                                              ),
                                        TextButton(
                                          onPressed: () async {
                                            await _pickImage();
                                            setState(
                                                () {}); // Rebuild the content after picking image
                                          },
                                          child: const Text(
                                            "Upload Image",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          controller: _nameController,
                                          decoration: InputDecoration(
                                              labelText: 'Name'),
                                        ),
                                        TextField(
                                          controller: _contactNumberController,
                                          decoration: InputDecoration(
                                              labelText: 'Contact Number'),
                                        ),
                                        TextField(
                                          controller: _addressController,
                                          decoration: InputDecoration(
                                              labelText: 'Address'),
                                        ),
                                        TextField(
                                          controller: _emailController,
                                          decoration: InputDecoration(
                                              labelText: 'Email'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () async {
                                    String name = _nameController.text;
                                    String contactNumber =
                                        _contactNumberController.text;
                                    String address = _addressController.text;
                                    String email = _emailController.text;
                                    Navigator.of(context).pop();

                                    await updateUserProfile(userId!, name,
                                        contactNumber, address, email);
                                  },
                                  child: Text('Save'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text("Edit Profile"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            _passwordController
                                .clear(); // Clear the password field on each dialog open

                            return AlertDialog(
                              title: Text('Change Password'),
                              content: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: _passwordController,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            labelText: 'New Password',
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () async {
                                    String newPassword =
                                        _passwordController.text;

                                    Navigator.of(context)
                                        .pop(); // Close the dialog

                                    await changePassword(userId!, newPassword);
                                  },
                                  child: Text('Change'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text('Cancel'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text("Change Password"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? userId = Provider.of<UserProvider>(context).userId;
    if (userId != null) {
      return FutureBuilder<Map<String, dynamic>>(
        future: _userDetailsFuture,
        builder: (context, snapshot) {
          print('Connection State: ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('Waiting for data...');
            return CircularProgressIndicator();
          } else if (snapshot.hasError || snapshot.data == null) {
            print('Error loading user details: ${snapshot.error}');
            return Text('Error loading user details');
          } else {
            Map<String, dynamic> userDetails = snapshot.data!;
            print('User details loaded successfully: $userDetails');
            return buildProfileWidget(userDetails, userId);
          }
        },
      );
    } else {
      return Text('User ID not available');
    }
  }
}
