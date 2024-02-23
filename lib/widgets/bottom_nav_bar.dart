import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        onTap: onTap,
        unselectedItemColor: const Color(0xFF050404).withOpacity(0.3),
        selectedItemColor: const Color(0xFF050404).withOpacity(0.8),
        iconSize: 30,
        selectedLabelStyle: const TextStyle(
          fontSize: 0,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 0,
        ),
        items: List.generate(5, (index) {
          IconData iconData = Icons.quiz_rounded;
          switch (index) {
            case 0:
              iconData = Icons.quiz_rounded;
              break;
            case 1:
              iconData = Icons.pending_actions_rounded;
              break;
            case 2:
              iconData = Icons.home;
              break;
            case 3:
              iconData = Icons.person;
              break;
            case 4:
              iconData = Icons.wechat_rounded;
              break;
          }
          return BottomNavigationBarItem(
            icon: Icon(
              iconData,
              size: currentIndex == index ? 35 : 30,
            ),
            label: '',
          );
        }),
      ),
    );
  }
}
