import 'dart:async';
import 'dart:io';
import 'package:customer_app/widgets/custom_image_upload.dart';
import 'package:customer_app/widgets/custom_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  TextEditingController nameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  File? _image;
  final imageStreamController = StreamController<File?>.broadcast();

  Future<void> _takeImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      imageStreamController.sink.add(imageFile);

      setState(() {
        _image = imageFile;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      imageStreamController.sink.add(imageFile);

      setState(() {
        _image = imageFile;
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

  Future<void> updateUserProfile(String userId, String name,
      String contactNumber, String address, String email) async {
    final userData = await fetchUserDetails(userId);
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: LoadingAnimationWidget.flickr(
              leftDotColor: const Color(0xFF050404).withOpacity(0.8),
              rightDotColor: const Color(0xFFd41111).withOpacity(0.8),
              size: 40,
            ),
          );
        },
      );

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
          '__t': "Customer",
          'address': address,
          'email': email,
          'image': userData["image"],
        }),
      );

      if (response.statusCode == 200) {
        print('User updated successfully');
        print('Response.statusCode: ${response.statusCode}');
        print(response.body);

        Navigator.of(context).pop();

        final updatedUserData = await fetchUserDetails(userId);
        setState(() {
          _userDetailsFuture = Future.value(updatedUserData);
        });
      } else {
        print('Failed to update user details: ${response.statusCode}');
        print(response.body);
        Navigator.of(context).pop();
      }
    } catch (error) {
      print('Error updating user details: $error');
      Navigator.of(context).pop();
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

  // Di gumagana Change Password
  Future<void> changePassword(String userId, String newPassword) async {
    try {
      final response = await Dio().patch(
        'https://lpg-api-06n8.onrender.com/api/v1/users/$userId/password',
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
        elevation: 1,
        title: Text(
          'Profile',
          style: TextStyle(
            color: const Color(0xFF050404).withOpacity(0.9),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: const Color(0xFF050404).withOpacity(0.8),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.black,
            height: 0.2,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          String? userId =
              Provider.of<UserProvider>(context, listen: false).userId;
          return fetchUserDetails(userId!);
        },
        color: const Color(0xFF050404),
        strokeWidth: 2.5,
        child: Container(
          color: const Color(0xFF050404).withOpacity(0.1),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                SizedBox(
                  height: 150,
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.transparent,
                        child: Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 150 / 2.2),
                            child: Container(
                              height: 150,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.elliptical(50, 50),
                                  topRight: Radius.elliptical(50, 50),
                                ),
                                color: Colors.white,
                              ),
                              child: Container(
                                height: 10,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.elliptical(45, 45),
                                    topRight: Radius.elliptical(45, 45),
                                  ),
                                  border: Border(
                                    top: BorderSide(
                                      color: Color(0xFF050404),
                                      width: 3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF050404),
                                  width: 1,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage: userData['image'] != null
                                    ? NetworkImage(userData['image']!)
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
                                    buildInfoRow(context, 'Name:',
                                        '${userData['name']}'),
                                    buildInfoRow(
                                      context,
                                      'Address:',
                                      '${userData['address']}',
                                    ),
                                    buildInfoRow(
                                      context,
                                      'Mobile Number:',
                                      '${userData['contactNumber']}',
                                    ),
                                    buildInfoRow(
                                      context,
                                      'Email Address:',
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
                                    StatusButton(
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
                                                DateTime.parse(userData[
                                                    'appointmentDate']),
                                              ),
                                            ),
                                            buildInfoRow(
                                              context,
                                              'Time:',
                                              DateFormat('h:mm a ').format(
                                                DateTime.parse(userData[
                                                    'appointmentDate']),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            if (userData['appointmentStatus'] == "Pending" ||
                                userData['appointmentStatus'] == "Approved")
                              if (isCardVisible)
                                Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    StatusButton(
                                      onPressed: _hideAppointmentCard,
                                      text: " View Appointment ",
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
                                          nameController.text =
                                              userData['name'] ?? '';
                                          contactNumberController.text =
                                              userData['contactNumber'] ?? '';
                                          addressController.text =
                                              userData['address'] ?? '';
                                          emailController.text =
                                              userData['email'] ?? '';
                                          return AlertDialog(
                                            title: const Center(
                                              child: Text(
                                                'Edit Personal Information',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            content: StatefulBuilder(
                                              builder: (BuildContext context,
                                                  StateSetter setState) {
                                                return SingleChildScrollView(
                                                  child: Form(
                                                    key: formKey,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Divider(),
                                                        StreamBuilder<File?>(
                                                          stream:
                                                              imageStreamController
                                                                  .stream,
                                                          builder: (context,
                                                              snapshot) {
                                                            return Column(
                                                              children: [
                                                                Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  children: [
                                                                    Center(
                                                                      child: snapshot.data !=
                                                                              null
                                                                          ? CircleAvatar(
                                                                              radius: 50,
                                                                              backgroundImage: FileImage(snapshot.data!),
                                                                            )
                                                                          : (userData['image'] != null && userData['image'].toString().isNotEmpty)
                                                                              ? CircleAvatar(
                                                                                  radius: 50,
                                                                                  backgroundImage: NetworkImage(
                                                                                    userData['image'].toString(),
                                                                                  ),
                                                                                )
                                                                              : const Icon(
                                                                                  Icons.person,
                                                                                  color: Colors.white,
                                                                                  size: 50,
                                                                                ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                ImageUploader(
                                                                  takeImage:
                                                                      _takeImage,
                                                                  pickImage:
                                                                      _pickImage,
                                                                  buttonText:
                                                                      "Upload Profile Image",
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                        EditTextField(
                                                          controller:
                                                              nameController,
                                                          labelText:
                                                              'Full Name',
                                                          hintText:
                                                              'Enter your Full Name',
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return "Please Enter your Full Name";
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                        ),
                                                        EditTextField(
                                                          controller:
                                                              contactNumberController,
                                                          labelText:
                                                              'Mobile Number',
                                                          hintText:
                                                              'Enter your Mobile Number',
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly,
                                                          ],
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return "Please Enter your Mobile Number";
                                                            } else if (value
                                                                    .length !=
                                                                11) {
                                                              return "Please Enter the Correct Mobile Number";
                                                            } else if (!value
                                                                .startsWith(
                                                                    '09')) {
                                                              return "Please Enter the Correct Mobile Number";
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                        ),
                                                        EditTextField(
                                                          controller:
                                                              addressController,
                                                          labelText: 'Address',
                                                          hintText:
                                                              'Enter your Address',
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return "Please Enter your Address";
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                        ),
                                                        EditTextField(
                                                          controller:
                                                              emailController,
                                                          labelText:
                                                              'Email Address',
                                                          hintText:
                                                              'Enter your Email Address',
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return "Please Enter Email Address";
                                                            } else if (!RegExp(
                                                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                                                .hasMatch(
                                                                    value)) {
                                                              return "Please Enter Correct Email Address";
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF050404)
                                                          .withOpacity(0.7),
                                                ),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    String name =
                                                        nameController.text;
                                                    String contactNumber =
                                                        contactNumberController
                                                            .text;
                                                    String address =
                                                        addressController.text;
                                                    String email =
                                                        emailController.text;
                                                    Navigator.of(context).pop();

                                                    await updateUserProfile(
                                                        userId!,
                                                        name,
                                                        contactNumber,
                                                        address,
                                                        email);
                                                  }
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF050404)
                                                          .withOpacity(0.9),
                                                ),
                                                child: const Text(
                                                  'Save',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    text: 'Edit Personal Information',
                                  ),
                                  const SizedBox(height: 5),
                                  ProfileButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          passwordController.clear();
                                          return AlertDialog(
                                            title: const Center(
                                              child: Text(
                                                'Change Password',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            content: StatefulBuilder(
                                              builder: (BuildContext context,
                                                  StateSetter setState) {
                                                return SingleChildScrollView(
                                                  child: Form(
                                                    key: formKey,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        EditTextField(
                                                          controller:
                                                              passwordController,
                                                          labelText:
                                                              'New Password',
                                                          hintText:
                                                              'Enter your New password',
                                                          obscureText: true,
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return 'Please enter your New Password';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF050404)
                                                          .withOpacity(0.7),
                                                ),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    String newPassword =
                                                        passwordController.text;
                                                    Navigator.of(context).pop();
                                                    await changePassword(
                                                        userId!, newPassword);
                                                  }
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF050404)
                                                          .withOpacity(0.9),
                                                ),
                                                child: const Text(
                                                  'Save',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Logout Account",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: const Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text(
              'Are you sure you want to log out?',
              style: TextStyle(fontSize: 14),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF050404).withOpacity(0.7),
              ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/login');
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFd41111).withOpacity(0.8),
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
            // overflow: TextOverflow.ellipsis,
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
                      ? Colors.red // const Color(0xFFd41111).withOpacity(0.8),
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
            return Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: const Color(0xFF050404).withOpacity(0.8),
                rightDotColor: const Color(0xFFd41111).withOpacity(0.8),
                size: 40,
              ),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            print('Error loading user details: ${snapshot.error}');
            return const Text('Error loading user details');
          } else {
            Map<String, dynamic> userDetails = snapshot.data!;
            print('User details loaded successfully: $userDetails');
            return buildProfileWidget(userDetails, userId);
          }
        },
      );
    } else {
      return const Text('User ID not available');
    }
  }
}
