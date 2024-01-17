import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medical_app/Constants.dart';
import 'package:medical_app/HomeScreen.dart';
import 'package:medical_app/agepage.dart';
import 'package:http/http.dart' as http;
import 'package:medical_app/constants/ipaddress.dart';
import 'package:medical_app/sexpage.dart';

class ProfileScreen extends StatefulWidget {
  final String userEmail;

  ProfileScreen({required this.userEmail});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late PageController _pageController;
  late String name = '';
  late String sex = '';
  late int age = 0;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: 0); // Set the initialPage to skip NamePage
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              children: [
                // Remove NamePage
                // NamePage(
                //   onNext: (String newName) {
                //     setState(() {
                //       name = newName;
                //       _currentPageIndex = 1;
                //     });
                //     _pageController.animateToPage(
                //       1,
                //       duration: Duration(milliseconds: 500),
                //       curve: Curves.ease,
                //     );
                //   },
                //   enteredName: '',
                // ),
                SexPage(
                  onNext: (String newSex) {
                    setState(() {
                      sex = newSex;
                      _currentPageIndex = 1; // Adjust the current page index
                    });
                    _pageController.animateToPage(
                      1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  },
                ),
                AgePage(
                  onNext: (int newAge) {
                    setState(() {
                      age = newAge;
                      _currentPageIndex = 2; // Adjust the current page index
                    });
                    _pageController.animateToPage(
                      2,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                    _saveAndNavigateToHome();
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            color: ColorConst.Agreen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Update the onPressed logic for the back button
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _currentPageIndex > 0
                      ? () {
                          if (_currentPageIndex == 1) {
                            // Handle skipping the NamePage
                            _pageController.animateToPage(
                              0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          } else {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          }
                        }
                      : null,
                ),
                Text(
                  'Step ${_currentPageIndex + 1} of 2', // Adjust the step count
                  style: TextStyle(color: Colors.white),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: _currentPageIndex < 1
                      ? () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateUserProfile() async {
    final updatedProfile = {
      'user_name': name,
      'user_age': age,
      'user_sex': sex,
      'user_email': widget.userEmail,
      // Add other fields as needed
    };

    try {
      final response = await http.post(
        Uri.parse('http://$ipconst:3000/api/auth/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedProfile),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully');
      } else {
        print('Failed to update profile: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating profile: $error');
    }
  }

  void _saveAndNavigateToHome() async {
    updateUserProfile();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(
          userEmail: widget.userEmail,
        ),
      ),
    );
  }
}
