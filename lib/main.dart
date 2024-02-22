import 'package:base_app/screens/userpage/UserPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
    routes: {
      '/userPage': (context) => UserPage(),
      // Other routes if needed
    },// Set LoginPage as the entry point
  ));
}
