import 'package:base_app/screens/Statistics.dart';
import 'package:base_app/screens/userpage/UserPage.dart'; // Assuming this is where your UserPage is defined
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final PageController _pageController = PageController(initialPage: 0);
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
          Statistics(),
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
        animationDuration: Duration(milliseconds: 300),
        index: _currentIndex,
        items: <Widget>[
          Icon(Icons.home),
          Icon(Icons.bar_chart_rounded),
        ],
        onTap: (int index) {
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        },
      ),
    );
  }
}
