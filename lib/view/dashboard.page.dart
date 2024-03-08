import 'package:customer_app/view/chat.page.dart';
import 'package:customer_app/view/faq.page.dart';
import 'package:customer_app/view/my_orders.page.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _retrieveCurrentIndex();
  }

  void _retrieveCurrentIndex() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is int) {
      setState(() {
        _currentIndex = args;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildTopBar(),
            Expanded(
              child: _currentIndex == 4
                  ? ChatPage()
                  : _currentIndex == 3
                      ? ProfilePage()
                      : _currentIndex == 0
                          ? FaqPage()
                          : _currentIndex == 2
                              ? HomePage()
                              : _currentIndex == 1
                                  ? MyOrderPage()
                                  : Center(
                                      child: Text(
                                          'Welcome to Page $_currentIndex'),
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
