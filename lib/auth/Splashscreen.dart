import 'dart:async';
import 'package:base_app/auth/LoginPage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay to simulate a splash screen
    Timer(Duration(seconds: 5), () {
      // Navigate to the login page after the delay
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
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
