import 'package:customer_app/view/home.page.dart';
import 'package:customer_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildTopBar(),
            Expanded(
              child: _currentIndex == 2
                  ? HomePage() // Navigate to HomePage when index is 0
                  : Center(
                      child: Text('Welcome to Page $_currentIndex'),
                    ),
            ),
            BottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTopBar() {
    return const Column(
      children: [],
    );
  }
}
