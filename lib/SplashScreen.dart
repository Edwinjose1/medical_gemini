import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medical_app/Constants.dart';
import 'package:medical_app/HomeScreen.dart';
import 'package:medical_app/main.dart';
import 'package:medical_app/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a time-consuming operation, like loading data or initializing
    Timer(
      Duration(seconds: 3), // Change the duration as needed
      () {
        // Navigate to the next screen after the splash screen duration
        checkUserLoggedIn(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.Agreen,
      // Customize the splash screen UI here
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Example of a logo
            SizedBox(height: 20),
            Text(
              'Medical App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> gotoLogin() async {
    await Future.delayed(Duration(seconds: 1));
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  Future<void> checkUserLoggedIn(BuildContext context) async {
    final sharedpref = await SharedPreferences.getInstance();
    final userLoggedIn = sharedpref.getBool(SAVE_KEY_NAME);
    String? storedEmail = sharedpref.getString('user_email');
    print(storedEmail);
    print(userLoggedIn);

    if (storedEmail != null && storedEmail.isNotEmpty) {
      if (userLoggedIn == null || userLoggedIn == false) {
        gotoLogin();
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MyHomePage(userEmail: storedEmail)));
      }

      // Use storedEmail to fetch data from the database or perform actions
      // Proceed with normal Home Page logic
    } else {
      gotoLogin();
      // Redirect to the Login Page to re-authenticate
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }
}
