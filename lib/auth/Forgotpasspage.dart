import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({Key? key}) : super(key: key);

  @override
  _ForgotPassPageState createState() => _ForgotPassPageState();
}

bool isEmailValid(String email) {
  final emailRegex = RegExp(r'^[a-z0-9]+@[a-z0-9]+\.[c][o][m]$');
  return emailRegex.hasMatch(email);
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Link Successfully Sent'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 52, 136, 205),
              const Color.fromARGB(255, 248, 232, 232)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                'Enter your Email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30, // Set font size to match the "Login" text
                  fontFamily: 'noto serif', // Add fontFamily property
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 60), // Adjust horizontal padding
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                  prefixIcon: Icon(Icons.email), // Icon before the input field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 52, 136, 205),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
                validator: (value) {
                  final email = _emailController.text;
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!isEmailValid(email)) {
                    return 'Invalid Mail Id';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
                height:
                    10), // Add some spacing between TextFormField and MaterialButton
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: MaterialButton(
                onPressed: passwordReset, // Define onPressed function
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                minWidth: 80,
                height: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
