import 'package:base_app/HomeScreen.dart';
import 'package:base_app/SignUp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Forgotpasspage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text;

      // Sign in with email and password
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Navigate to the next screen after successful login
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ));
    } catch (e) {
      // Handle sign-in errors
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: Form(
        key: _formKey,
        autovalidateMode:
            AutovalidateMode.always, // Enable automatic validation
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Login to your account",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[700]),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust vertical padding as needed
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: "Email",
                              ),
                              validator: (value) {
                                final email = _emailController.text;
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!isEmailValid(email)) {
                                  return 'Invalid Mail Id include @ and make sure it ends with .com';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust vertical padding as needed
                            child: TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: "Password",
                              ),
                              obscureText: true,
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
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
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
                              'Forgot Password'
                              " Sign up",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 0, left: 0, right: 0, bottom: 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border(
                              bottom: BorderSide(color: Colors.black),
                              top: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),
                            )),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Form is valid, handle login logic here
                              // For example, you can navigate to another page
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                              // await FirebaseFirestore.instance.collection('').add(data)
                              _signInWithEmailAndPassword();
                            }
                          },
                          color: Colors.blue,
                          elevation: 0,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Don't have an account?"),
                        GestureDetector(
                          onTap: () {
                            // Add your onPressed function here to navigate to the sign-up page or perform any other action.
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Signup()));
                          },
                          child: Text(
                            " Sign up",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.blue, // Set the color to blue
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 100),
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/background.png"),
                            fit: BoxFit.fitHeight),
                      ),
                    )
                  ],
                ),
              )
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
