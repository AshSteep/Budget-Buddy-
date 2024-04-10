import 'package:base_app/auth/loginPage.dart';
import 'package:base_app/auth/splashscreen.dart';
import 'package:base_app/blockchain/notes_services.dart';

import 'package:base_app/components/bottomnavbar.dart';
import 'package:base_app/screens/userpage/UserPage.dart';
import 'package:base_app/screens/userpage/addtransaction.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (context) => NotesServices(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Show SplashScreen first
      routes: {
        '/login': (context) => LoginPage(),
        '/userPage': (context) => UserPage(),
        '/bottomNav': (context) => BottomNavBar(),
        '/addtransaction': (context) => AddTransaction(),

        // Other routes if needed
      },
    );
  }
}
