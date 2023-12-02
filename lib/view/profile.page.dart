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
  @override
  Widget build(BuildContext context) {
    // Access the UserProvider to get the userId
    String? userId = Provider.of<UserProvider>(context).userId;

    // Check if userId is available
    if (userId != null) {
      return FutureBuilder<Map<String, dynamic>>(
        future: fetchUserDetails(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError || snapshot.data == null) {
            return Text('Error loading user details');
          } else {
            Map<String, dynamic> userDetails = snapshot.data!;
            return buildProfileWidget(userDetails);
          }
        },
      );
    } else {
      // Handle the case where userId is null
      return Text('User ID not available');
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

  Widget buildProfileWidget(Map<String, dynamic> userDetails) {
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Card(
            color: const Color(0xFF232937),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Registered Customer',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                if (userData.containsKey('image') && userData['image'] != null)
                  CircleAvatar(
                    radius: 60, // Adjust the radius as needed
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
                  'Email: ${userData['email'] ?? 'N/A'}',
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
                Text(
                  'Appointment Date: ${userData['dateInterview'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Appointment Time: ${userData['timeInterview'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                // Add more fields as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
