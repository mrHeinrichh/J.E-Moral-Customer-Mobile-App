import 'dart:io';
import 'package:customer_app/routes/app_routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:customer_app/view/user_provider.dart';
import 'package:customer_app/widgets/custom_button.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';

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

      await _uploadSelectedImage();
    }

    print(_image);
  }

  Future<void> _uploadSelectedImage() async {
    if (_image != null) {
      final serverResponse = await uploadImageToServer(_image!);

      if (serverResponse != null) {
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

  // Future<void> updateUserProfile(String userId, String name,
  //     String contactNumber, String address, String email) async {
  //   try {
  //     final userData = await fetchUserDetails(userId);

  //     if (_image != null) {
  //       final serverResponse = await uploadImageToServer(_image!);

  //       if (serverResponse != null) {
  //         final imageUrl = serverResponse['data'][0]['path'];
  //         userData["image"] = imageUrl;
  //       }
  //     }

  //     final response = await http.patch(
  //       Uri.parse('https://lpg-api-06n8.onrender.com/api/v1/users/$userId'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'image': userData["image"],
  //         'name': name,
  //         'contactNumber': contactNumber,
  //         'type': "Customer",
  //         'address': address,
  //         'email': email,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       print('User updated successfully');
  //       print('Response.statusCode: ${response.statusCode}');
  //       print(response.body);

  //       setState(() {});
  //     } else {
  //       print('Failed to update user details: ${response.statusCode}');
  //       print(response.body);
  //     }
  //   } catch (error) {
  //     print('Error updating user details: $error');
  //   }
  // }

  Future<void> updateUserProfile(String userId, String name,
      String contactNumber, String address, String email) async {
    final userData = await fetchUserDetails(userId);

    try {
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
          'name': name,
          'contactNumber': contactNumber,
          'type': "Customer",
          'address': address,
          'email': email,
          'image': userData["image"],
        }),
      );

      if (response.statusCode == 200) {
        print('User updated successfully');
        print('Response.statusCode: ${response.statusCode}');
        print(response.body);

        final updatedUserData = await fetchUserDetails(userId);
        setState(() {
          _userDetailsFuture = Future.value(updatedUserData);
        });
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

  Future<void> _handleRefresh() async {
    // Reload user details when pulling down to refresh
    String? userId = Provider.of<UserProvider>(context, listen: false).userId;
    setState(() {
      _userDetailsFuture = fetchUserDetails(userId!);
    });
  }

  @override
  void initState() {
    super.initState();
    String? userId = Provider.of<UserProvider>(context, listen: false).userId;
    _userDetailsFuture = fetchUserDetails(userId!);
    print(userId);
  }

  bool isViewAppointmentVisible = true;
  bool isCardVisible = false;

  void _showAppointmentCard() {
    setState(() {
      isViewAppointmentVisible = false;
      isCardVisible = true;
    });
  }

  void _hideAppointmentCard() {
    setState(() {
      isViewAppointmentVisible = true;
      isCardVisible = false;
    });
  }

  Widget buildProfileWidget(Map<String, dynamic> userDetails, String? userId) {
    final userData = userDetails['data'][0];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(
            'Profile',
            style: TextStyle(color: Color(0xFF232937), fontSize: 24),
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFF232937)),
            onSelected: (String result) {
              if (result == 'logout') {
                Navigator.pushNamed(context, '/login');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Log out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        // physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              // or Container(
              height: 200,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 150 / 2.2),
                    child: Container(
                      height: 150,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(50, 50),
                          bottomRight: Radius.elliptical(50, 50),
                        ),
                        color: Color(0xFF232937),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // CircleAvatar(
                        //   radius: 30,
                        //   backgroundColor: Color(0xffD8D8D8),
                        //   child: Icon(
                        //     Icons.chat,
                        //     size: 30,
                        //     color: Color(0xff6E6E6E),
                        //   ),
                        // ),
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: userData['image'] != null
                              ? NetworkImage(userData['image']!)
                              : null,
                        ),
                        // CircleAvatar(
                        //   radius: 30,
                        //   backgroundColor: Color(0xffD8D8D8),
                        //   child: Icon(
                        //     Icons.call,
                        //     size: 30,
                        //     color: Color(0xff6E6E6E),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            "Personal Information",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .apply(color: Colors.black),
                          ),
                          const Divider(),
                          buildInfoRow(context, 'Name:', '${userData['name']}'),
                          buildInfoRow(
                            context,
                            'Address:',
                            '${userData['address']}',
                          ),
                          buildInfoRow(
                            context,
                            'Contact Number:',
                            '${userData['contactNumber']}',
                          ),
                          buildInfoRow(
                            context,
                            'Email:',
                            '${userData['email']}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (userData['appointmentStatus'] == "Pending" ||
                      userData['appointmentStatus'] == "Approved")
                    Column(
                      children: [
                        if (isViewAppointmentVisible)
                          ProfileButton(
                            onPressed: _showAppointmentCard,
                            text: "View Appointment",
                          ),
                        if (isCardVisible)
                          Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Appointment Schedule!",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .apply(color: Colors.black),
                                  ),
                                  Text(
                                    "*Applying as a Delivery Driver*",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .apply(color: Colors.black),
                                  ),
                                  const Divider(),
                                  buildInfoRowStatus(
                                    context,
                                    'Status: ',
                                    '${userData['appointmentStatus']}',
                                    userData,
                                  ),
                                  buildInfoRow(
                                    context,
                                    'Date:',
                                    DateFormat('MMM d, y').format(
                                      DateTime.parse(
                                          userData['appointmentDate']),
                                    ),
                                  ),
                                  buildInfoRow(
                                    context,
                                    'Time:',
                                    DateFormat('h:mm a ').format(
                                      DateTime.parse(
                                          userData['appointmentDate']),
                                    ),
                                  ),
                                  // ProfileButton(
                                  //   onPressed: () async {
                                  //     Navigator.pushNamed(
                                  //         context, appointmentRoute);
                                  //   },
                                  //   text: "Update Appointment",
                                  // ),
                                  // const SizedBox(height: 5),
                                  // OkButton(
                                  //   onPressed: _hideAppointmentCard,
                                  //   text: "Ok",
                                  // ),
                                  ProfileButton(
                                    onPressed: _hideAppointmentCard,
                                    text: "Ok",
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        ProfileButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                _nameController.text = userData['name'] ?? '';
                                _contactNumberController.text =
                                    userData['contactNumber'] ?? '';
                                _addressController.text =
                                    userData['address'] ?? '';
                                _emailController.text = userData['email'] ?? '';
                                return AlertDialog(
                                  title: const Text('Edit Profile'),
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
                                                    backgroundColor:
                                                        Colors.grey,
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
                                                setState(() {});
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
                                              decoration: const InputDecoration(
                                                  labelText: 'Name'),
                                            ),
                                            TextField(
                                              controller:
                                                  _contactNumberController,
                                              decoration: const InputDecoration(
                                                  labelText: 'Contact Number'),
                                            ),
                                            TextField(
                                              controller: _addressController,
                                              decoration: const InputDecoration(
                                                  labelText: 'Address'),
                                            ),
                                            TextField(
                                              controller: _emailController,
                                              decoration: const InputDecoration(
                                                  labelText: 'Email'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        String name = _nameController.text;
                                        String contactNumber =
                                            _contactNumberController.text;
                                        String address =
                                            _addressController.text;
                                        String email = _emailController.text;
                                        Navigator.of(context).pop();

                                        await updateUserProfile(userId!, name,
                                            contactNumber, address, email);
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          text: 'Edit Profile',
                        ),
                        const SizedBox(height: 5),
                        ProfileButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                _passwordController.clear();
                                return AlertDialog(
                                  title: const Text('Change Password'),
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
                                              decoration: const InputDecoration(
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
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        String newPassword =
                                            _passwordController.text;
                                        Navigator.of(context).pop();

                                        await changePassword(
                                            userId!, newPassword);
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          text: "Change Password",
                        ),
                        const SizedBox(height: 50),
                        ProfileButton(
                          onPressed: () {
                            _showLogoutConfirmationDialog(context);
                          },
                          text: 'Logout',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/login');
              },
              style: TextButton.styleFrom(
                primary: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Widget buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget buildInfoRowStatus(BuildContext context, String label, String value,
      Map<String, dynamic> userData) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: userData['appointmentStatus'] == "Pending"
                      ? Colors.red
                      : Colors.green,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
            return const CircularProgressIndicator();
          } else if (snapshot.hasError || snapshot.data == null) {
            print('Error loading user details: ${snapshot.error}');
            return const Text('Error loading user details');
          } else {
            Map<String, dynamic> userDetails = snapshot.data!;
            print('User details loaded successfully: $userDetails');
            return RefreshIndicator(
              onRefresh: _handleRefresh,
              child: buildProfileWidget(userDetails, userId),
            );
          }
        },
      );
    } else {
      return const Text('User ID not available');
    }
  }
}
