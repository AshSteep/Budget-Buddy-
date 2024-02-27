import '../screens/AdminPage.dart';
import 'package:base_app/auth/SignUp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Forgotpasspage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text;

      // Sign in with email and password
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Get the current user's UID
      String userUID = _auth.currentUser!.uid;

      // Access Firestore collection 'users' and document with UID
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .get();

      // Check if the document exists and userType is 'admin'
      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        String userType = userData['userType'];

        if (userType == 'admin') {
          // User is an admin
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AdminPage(), // Replace with the admin page
          ));
        } else {
          // User is not an admin
          Navigator.of(context)
              .pushReplacementNamed('/bottomNav', arguments: userUID);
        }
      } else {
        // Document with UID doesn't exist
        // Handle this case (user document not found)
      }
    } catch (e) {
      // Handle sign-in errors
      print("Error: $e");
      // Perform error handling
      String errorMessage = "Invalid credentials. Please try again.";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await _googleSignIn.signOut(); // To force account selection each time
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google sign-in aborted');
        return;
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken!,
          idToken: googleAuth.idToken!,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        String userUID = _auth.currentUser!.uid;
        Navigator.of(context)
            .pushReplacementNamed('/bottomNav', arguments: userUID);
      } else {
        print('ID token or Access token is null');
      }
    } catch (e, s) {
      print("Error: $e, StackTrace: $s");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
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
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'noto serif',
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Login to your account",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 42, 39, 39)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: "Email",
                                hintText: "Enter your email",
                                prefixIcon: Icon(
                                    Icons.email), // Icon before the input field
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 52, 136, 205),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20.0),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: "Password",
                                hintText: "Enter your password",
                                prefixIcon: Icon(
                                    Icons.lock), // Icon before the input field
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 52, 136, 205),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20.0),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 15.0,
                                ),
                              ),
                              obscureText: true,
                              validator: (value) {
                                final password = _passwordController.text;
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (!isPasswordValid(password)) {
                                  return 'Please enter a valid password ';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ForgotPassPage();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: const Color.fromARGB(255, 14, 20, 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 60),
                          child: Container(
                            child: MaterialButton(
                              minWidth: 300,
                              height: 60,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _signInWithEmailAndPassword();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Please enter credentials'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              color: Colors.blue,
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 20), // Adjust the spacing between buttons

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 60),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.black),
                            ),
                            child: MaterialButton(
                              minWidth: 300,
                              height: 60,
                              onPressed: () {
                                _signInWithGoogle(context);
                              },
                              color: Colors.white,
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/google_logo.png',
                                    width: 30,
                                    height: 30, // Replace with your asset path
                                    // Ensure the image covers the available space
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Sign in with Google",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Don't have an account?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Signup()));
                          },
                          child: Text(
                            " Sign up",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: const Color.fromARGB(255, 11, 15, 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[a-z0-9]+@[a-z0-9]+\.[c][o][m]$');
    return emailRegex.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    final passwordRegex =
        RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{6,}$');
    return passwordRegex.hasMatch(password);
  }
}
