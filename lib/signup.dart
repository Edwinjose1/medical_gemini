import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medical_app/Constants.dart';
import 'package:medical_app/HomeScreen.dart';
import 'package:medical_app/LoginScreen.dart';
import 'package:medical_app/constants/ipaddress.dart';
import 'package:medical_app/main.dart';
import 'package:medical_app/skippingpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  Color usernameBorderColor = Colors.grey;
  Color emailBorderColor = Colors.grey;
  Color passwordBorderColor = Colors.grey;
  Color confirmPasswordBorderColor = Colors.grey;
  Color phoneBorderColor = Colors.grey;

  bool _isLoading = false;

  Future<void> signUp() async {
    setState(() {
      _isLoading = true;
    });

    final String signUpUrl = 'http://${ipconst.ipaddress}:3000/api/auth/sign-up';

    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;
    String phoneNumber = phoneNumberController.text;

    Map<String, String> payload = {
      'user_name': username,
      'user_email': email,
      'user_password': password,
      'user_phone': phoneNumber,
    };

    try {
      var response = await http.post(
        Uri.parse(signUpUrl),
        body: jsonEncode(payload),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        print(responseData);

        if (responseData['status'] == "success") {
          final sharedpref = await SharedPreferences.getInstance();
          await sharedpref.setBool(SAVE_KEY_NAME, true);
          await sharedpref.setString('user_email', email);

          // Show loading indicator for 2 seconds
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Signing Up...'),
                  ],
                ),
              );
            },
          );

          // Delay for 2 seconds
          await Future.delayed(Duration(seconds: 2));

          // Pop the loading dialog
          // Navigator.pop(context);

          // Navigate to the new screen and remove all previous screens
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                userEmail: emailController.text,
              ),
            ),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color.fromARGB(255, 146, 82, 77),
              content: Text('You cannot signup with this email'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        var errorMessage = json.decode(response.body)['message'];
        print(errorMessage);
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorConst.Agreen,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 50),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: usernameBorderColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: emailBorderColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: ' Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: passwordBorderColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter confirm  password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: passwordBorderColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter confirm  password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: phoneBorderColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        setState(() {
                          if (_formKey.currentState!.validate()) {
                            // Validation passed, perform signup
                            if (passwordController.text !=
                                confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Passwords do not match'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              signUp();
                            }
                          } else {
                            // Validation failed, update border colors
                            // Update border colors for each field as red if empty
                            usernameBorderColor =
                                usernameController.text.isEmpty
                                    ? Colors.red
                                    : Colors.grey;
                            emailBorderColor = emailController.text.isEmpty
                                ? Colors.red
                                : Colors.grey;
                            passwordBorderColor =
                                passwordController.text.isEmpty
                                    ? Colors.red
                                    : Colors.grey;
                            confirmPasswordBorderColor =
                                confirmPasswordController.text.isEmpty
                                    ? Colors.red
                                    : Colors.grey;
                            phoneBorderColor =
                                phoneNumberController.text.isEmpty
                                    ? Colors.red
                                    : Colors.grey;
                          }
                        });
                      },
                style: ElevatedButton.styleFrom(
                  primary: ColorConst.Agreen,
                ),
                child: Text(
                  'SignUp',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: ColorConst.Agreen),
                    ),
                    Text(
                      '  Login',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 118, 100, 100)),
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
}
