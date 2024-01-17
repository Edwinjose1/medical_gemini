import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medical_app/Constants.dart';
import 'package:medical_app/HomeScreen.dart';
import 'package:medical_app/constants/ipaddress.dart';

class ProfileCreationPage extends StatefulWidget {
  final String userEmail;

  ProfileCreationPage({required this.userEmail});

  @override
  _ProfileCreationPageState createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  DateTime? selectedDate;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  bool editMode = false; // Add edit mode state
  bool isLoading = true; // To track loading state
  String? selectedGender; // Declare this at the class level

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://${ipconst.ipaddress}:3000/api/user/get-user-email?email=${widget.userEmail}'));

      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);

        if (jsonData['status'] == true) {
          final List<dynamic> usersData = jsonData['data'];
          if (usersData.isNotEmpty) {
            _nameController.text = usersData[0]['user_name'] ?? '';
            _ageController.text = usersData[0]['user_age']?.toString() ?? '';

            String? sexFromDatabase = usersData[0]['user_sex']?.toString();
            if (sexFromDatabase != null &&
                (sexFromDatabase == 'Male' || sexFromDatabase == 'Female')) {
              _sexController.text = sexFromDatabase;
            }

            selectedDate = DateTime.parse(usersData[0]['user_dob']);
            _dateController.text =
                "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";

            setState(() {
              isLoading = false;
            });
          }
        } else {
          print('Query was not successful: ${jsonData['message']}');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> updateUserProfile() async {
    final updatedProfile = {
      'user_name': _nameController.text,
      'user_age': int.tryParse(_ageController.text) ?? 0,
      // 'user_dob': _dateController.text,
      'user_sex': _sexController.text,
      'user_email': widget.userEmail
      // Add other fields as needed
    };

    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.1.41:3000/api/auth/update'), // Your API endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedProfile),
      );

      if (response.statusCode == 200) {
        // Successfully updated profile
        print('Profile updated successfully');
      } else {
        // Failed to update profile
        print('Failed to update profile: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.Agreen,
        title: Text('Create Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.0),
            _buildInputField('Name', _nameController),
            SizedBox(height: 20.0),
            _buildInputField('Age', _ageController),
            SizedBox(height: 20.0),
            _buildInputField(
                'Sex', _sexController), // Update the label to 'Sex'
            SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await updateUserProfile();
                    setState(() {
                      editMode = false; // Update edit mode after saving
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                userEmail: widget.userEmail,
                              )),
                    );
                  },
                  child: Text('Save Profile'),
                  style: ElevatedButton.styleFrom(
                    primary: ColorConst.Agreen,
                  ),
                ),
                // Toggle edit mode when the edit button is pressed
                editMode
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            editMode = false;
                          });
                        },
                        child: Text('Cancel'),
                      )
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            editMode = true;
                          });
                        },
                        child: Text('Edit'),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    if (label == 'Sex') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<String>(
                value: 'Male',
                groupValue: _sexController.text,
                onChanged: editMode
                    ? (String? value) {
                        setState(() {
                          _sexController.text = value!;
                        });
                      }
                    : null,
                activeColor: _sexController.text == 'Male' ? Colors.blue : null,
              ),
              const Text('Male'),
              Radio<String>(
                value: 'Female',
                groupValue: _sexController.text,
                onChanged: editMode
                    ? (String? value) {
                        setState(() {
                          _sexController.text = value!;
                        });
                      }
                    : null,
                activeColor:
                    _sexController.text == 'Female' ? Colors.blue : null,
              ),
              const Text('Female'),
            ],
          ),
          if (_sexController.text.isNotEmpty &&
              _sexController.text != 'Male' &&
              _sexController.text != 'Female')
            Center(
              child: Text(
                'Selected gender: ${_sexController.text}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
        ],
      );
    } else {
      return TextFormField(
        controller: controller,
        enabled: editMode,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorConst.Agreen),
          ),
        ),
      );
    }
  }
}
