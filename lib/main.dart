import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'SignUp.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  )); //MaterialApp
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        // we will give media query height
        // double.infinity make it big as my parent allows
        //while Media-query make it big as per the screen
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          //even space distribution
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text("Welcome",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    )),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Budget Buddy",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: AssetImage("assets/welcome.png"))),
            ),
            Column(
              children: <Widget>[
                //the login button
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  // defining the shape
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "LogIn",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
                // signup button
                SizedBox(height: 20),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signup()));
                  },
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: Text("Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18)),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
