import 'package:base_app/blockchain/home_screen.dart';
import 'package:base_app/screens/userpage/Statistics.dart';
import 'package:base_app/screens/userpage/UserPage.dart';
import 'package:base_app/screens/userpage/addtransaction.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), // Prevent scrolling
        children: [
          UserPage(),
          AddTransaction(),
          Statistics(),
          HomeScreen(),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        color: Color(0xFFF6573D3),
        animationDuration: Duration(milliseconds: 200),
        index: _currentIndex,
        items: <Widget>[
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.add, color: Colors.white),
          Icon(Icons.bar_chart_rounded, color: Colors.white),
          Icon(Icons.security, color: Colors.white),
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 10), curve: Curves.ease);
        },
      ),
    );
  }
}
