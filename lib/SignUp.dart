import 'package:base_app/LoginPage.dart';
import 'package:base_app/model/normal_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'HomeScreen.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore fire = FirebaseFirestore.instance;
  Future<void> createUser() async {
    try {
      // Create a new user with email and password
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      // Get the Firebase user object
      User? firebaseUser = authResult.user;

      if (firebaseUser != null) {
        // Create a UserModal object
        UserModel usermodel = UserModel(username: _usernameController.text);

        // Convert UserModal to a Map
        Map<String, dynamic> userMap = usermodel.toJson();

        // Add the user data to Firestore with the Firebase user's UID as the document ID
        await fire.collection('users').doc(firebaseUser.uid).set(userMap);

        // Successful user creation
        print('User created successfully with UID: ${firebaseUser.uid}');
      } else {
        // Handle case where firebaseUser is null
        print('User creation failed.');
      }
    } catch (e) {
      // Handle errors
      print('Error creating user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode
                .onUserInteraction, // Enable real-time validation
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Create an account, It's free ",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                      ),
                      onChanged: (_) => _formKey.currentState!
                          .validate(), // Validate on text change
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        if (!isUsernameValid(value)) {
                          return 'Username should not contain numbers or special characters';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                      ),
                      onChanged: (_) => _formKey.currentState!
                          .validate(), // Validate on text change
                      validator: (value) {
                        final email = _emailController.text;
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!isEmailValid(email)) {
                          return 'Please enter a valid email (lowercase, includes "@", and ends with ".com")';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                      ),
                      obscureText: true,
                      onChanged: (_) => _formKey.currentState!
                          .validate(), // Validate on text change
                      validator: (value) {
                        final password = _passwordController.text;
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (!isPasswordValid(password)) {
                          return 'Please enter a valid password (at least 6 characters, one uppercase, one lowercase, one number, and one special character)';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                      ),
                      obscureText: true,
                      onChanged: (_) => _formKey.currentState!
                          .validate(), // Validate on text change
                      validator: (value) {
                        final confirmPassword = _confirmPasswordController.text;
                        final password = _passwordController.text;
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (confirmPassword != password) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, handle signup logic here
                        try {
                          // Call your createUser function
                          await createUser();

                          // If createUser() is successful, navigate to the HomeScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                        } catch (e) {
                          // Handle any errors during sign-up
                          print('Error during sign-up: $e');
                        }
                      }
                    },
                    color: Colors.blue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account?"),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the login page when "Login" is tapped
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginPage()));
                      },
                      child: Text(
                        " Login",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.blue, //  Set the color to blue
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isUsernameValid(String username) {
    // Check if username contains only letters (no numbers or special characters)
    final usernameRegex = RegExp(r'^[a-zA-Z]+$');
    return usernameRegex.hasMatch(username);
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
