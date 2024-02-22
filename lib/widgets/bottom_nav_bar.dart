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
        // unselectedItemColor: const Color(0xFF050404).withOpacity(0.8),
        unselectedItemColor: const Color(0xFF312C28).withOpacity(0.5),
        // selectedItemColor: const Color(0xFF050404),
        selectedItemColor: const Color(0xFFE73C37).withOpacity(0.9),
        iconSize: 30,
        selectedLabelStyle: const TextStyle(
          fontSize: 0,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 0,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.quiz_rounded,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.pending_actions_rounded,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.wechat_rounded,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
