import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:customer_app/view/user_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _userDetailsFuture;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Access the UserProvider to get the userId
    String? userId = Provider.of<UserProvider>(context, listen: false).userId;
    // Initialize the Future in initState
    _userDetailsFuture = fetchUserDetails(userId!);
  }

  Future<void> updateUserProfile(
    String userId,
    String name,
    String contactNumber,
    String address,
  ) async {
    try {
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
        }),
      );

      print(name);
      print(contactNumber);
      print('User ID: $userId');

      if (response.statusCode == 200) {
        // User updated successfully
        print('User updated successfully');
        print('Response.statusCode: ${response.statusCode}');
        print(response.body);

        // Reload user details
        setState(() {
          // Trigger a rebuild of the widget with updated data
        });
      } else {
        // Handle error
        print('Failed to update user details: ${response.statusCode}');
        print(response.body); // Print the response body for debugging
      }
    } catch (error) {
      // Handle error
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

  Widget buildProfileWidget(Map<String, dynamic> userDetails, String? userId) {
    final userData = userDetails['data'];

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
                if (userData.containsKey('image') && userData['image'] != null)
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(userData['image'] as String),
                  ),
                Text(
                  'Full Name: ${userData['name'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Address: ${userData['address'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Contact Number: ${userData['contactNumber'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Show dialog on button click
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Enter Name and Contact Number'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(labelText: 'Name'),
                              ),
                              TextField(
                                controller: _contactNumberController,
                                decoration: InputDecoration(
                                    labelText: 'Contact Number'),
                              ),
                              TextField(
                                controller: _addressController,
                                decoration:
                                    InputDecoration(labelText: 'Address'),
                              ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                // Handle the data entered in the dialog
                                String name = _nameController.text;
                                String contactNumber =
                                    _contactNumberController.text;
                                String address = _addressController.text;

                                // Close the dialog
                                Navigator.of(context).pop();

                                // Update user profile
                                await updateUserProfile(
                                    userId!, name, contactNumber, address);
                              },
                              child: Text('Save'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Close the dialog without saving
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the UserProvider to get the userId
    String? userId = Provider.of<UserProvider>(context).userId;
    // Check if userId is available
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
      // Handle the case where userId is null
      return Text('User ID not available');
    }
  }
}
