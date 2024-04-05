import 'dart:async';
import 'package:base_app/auth/loginPage.dart';
import 'package:base_app/screens/userpage/UserPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay to simulate a splash screen
    Timer(Duration(seconds: 3), () async {
      // Navigate to the login page after the delay
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? logginned = await prefs.getString('email');
      print('loggin info $logginned');
      if (logginned != '') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => UserPage()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 6, 85, 121),
              const Color.fromARGB(255, 171, 205, 233)
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'BUDGET BUDDY',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Noto Serif',
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 246, 246),
                ),
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/welcome.png',
                width: 200, // Adjust the width as needed
              ),
            ],
          ),
        ),
      ),
    );
  }
}
