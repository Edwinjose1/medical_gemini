// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:medical_app/Constants.dart';
// import 'package:medical_app/Create_profile.dart';
// import 'package:medical_app/HomeScreen.dart';
// import 'package:medical_app/profile.dart';
// import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medical_app/Constants.dart';
import 'package:medical_app/HomeScreen.dart';
import 'package:medical_app/constants/ipaddress.dart';
import 'package:medical_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPVerificationPage extends StatefulWidget {
  final String userEmail;

  OTPVerificationPage({required this.userEmail});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController _otpController = TextEditingController();

  Future<void> verifyOTP() async {
    final String verifyOtpUrl = 'http://${ipconst.ipaddress}:3000/api/auth/verifyotp';

    Map<String, String> payload = {
      'user_email': widget.userEmail,
      'otp': _otpController.text,
    };

    try {
      var response = await http.post(
        Uri.parse(verifyOtpUrl),
        body: jsonEncode(payload),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        if (responseData['status'] == true) {
          _showSnackBar('Verification successful', Colors.green);

          final _sharedpref = await SharedPreferences.getInstance();

          await _sharedpref.setBool(SAVE_KEY_NAME, true);
          await _sharedpref.setString('user_email', widget.userEmail);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      userEmail: widget.userEmail,
                    )),
          );
        } else {
          _showSnackBar('Invalid OTP', Colors.red);
        }
      } else {
        var errorMessage = json.decode(response.body)['message'];
        _showSnackBar(errorMessage, Colors.red);
      }
    } catch (error) {
      print('Error: $error');
      _showSnackBar('Error occurred', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.Agreen,
        title: Text('OTP Verification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            SizedBox(height: 150),
            Text(
              'Enter the OTP sent to your phone',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            OTPForm(otpController: _otpController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                verifyOTP();

                // Add your onPressed logic here
              },
              style: ElevatedButton.styleFrom(
                primary: ColorConst.Agreen, // Set the background color here
                // Other styling properties can be added here like textStyle, elevation, shape, padding, etc.
              ),
              child: Text(
                'Verify',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OTPForm extends StatelessWidget {
  final TextEditingController otpController;

  OTPForm({required this.otpController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: otpController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Enter OTP',
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
      maxLength: 6,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter OTP';
        }
        return null;
      },
    );
  }
}
