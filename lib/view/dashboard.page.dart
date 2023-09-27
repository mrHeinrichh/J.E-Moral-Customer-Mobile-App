import 'package:customer_app/view/faq.page.dart';
import 'package:customer_app/view/history.page.dart';
import 'package:customer_app/view/home.page.dart';
import 'package:customer_app/view/profile.page.dart';
import 'package:customer_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

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
              child: _currentIndex == 3
                  ? ProfilePage()
                  : _currentIndex == 0
                      ? FaqPage() // Display FaqPage when index is 0
                      : _currentIndex == 2
                          ? HomePage() // Display HomePage when index is 2
                          : _currentIndex == 1
                              ? HistoryPage() // Display FaqPage when index is 3
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
