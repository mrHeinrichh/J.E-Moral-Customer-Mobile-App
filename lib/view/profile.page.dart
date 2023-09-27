import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
            color: const Color(0xFF232937), // Set card background color
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Registered Customer',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Set text color to white
                  ),
                ),
                Row(
                  children: [
                    Image.network(
                      'https://raw.githubusercontent.com/mrHeinrichh/J.E-Moral-cdn/main/assets/png/profile-image.png',
                      fit: BoxFit.cover, // You can adjust the fit as needed
                    ),
                  ],
                ),
                const Text(
                  'Full Name: Heinrich Fabros',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Set text color to white
                  ),
                ),
                const Text(
                  'Email: Heinrichsorbaf02@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Set text color to white
                  ),
                ),
                const Text(
                  'Address: 73 Fabros Residency',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Set text color to white
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
