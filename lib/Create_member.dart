import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:medical_app/Constants.dart';
import 'package:medical_app/constants/ipaddress.dart';

class ProfileForm extends StatefulWidget {
  final String parent_id;
  ProfileForm({required this.parent_id});
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String? _selectedSex;
  String? _selectedBloodGroup; // Track selected blood group
  String? _selectedRelation;

  // List of blood groups to be displayed in the dropdown
  List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];
  List<String> familyRelationships = [
    'Father',
    'Mother',
    'Daughter',
    'Son',
    'Wife',
    'Cousin'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.Agreen,
        title: Text('Create Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: ColorConst.Agreen),
                ),
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _heightController,
              decoration: InputDecoration(
                labelText: 'Height',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: ColorConst.Agreen),
                ),
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: 'Weight',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: ColorConst.Agreen),
                ),
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: ColorConst.Agreen),
                ),
              ),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedSex,
              decoration: InputDecoration(
                labelText: 'Sex',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: ColorConst.Agreen),
                ),
              ),
              items: <String>['Male', 'Female', 'Other'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedSex = newValue!;
                });
              },
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedBloodGroup,
              decoration: InputDecoration(
                labelText: 'Blood Group',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: ColorConst.Agreen),
                ),
              ),
              items: bloodGroups.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedBloodGroup = newValue!;
                });
              },
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedRelation,
              decoration: InputDecoration(
                labelText: 'Relation',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: ColorConst.Agreen),
                ),
              ),
              items: familyRelationships.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedRelation = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _submitProfile(widget.parent_id);
                    Navigator.of(context).pop();
                  },
                  child: Text('Submit', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    primary: ColorConst.Agreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitProfile(String parent_id) {
    String name = _nameController.text;
    String height = _heightController.text;
    String weight = _weightController.text;
    String age = _ageController.text;
    String sex = _selectedSex ?? 'Not Specified';
    String bloodGroup = _selectedBloodGroup ?? 'Not Specified';
    String relation = _selectedRelation ?? 'Not Specifed';

    print('Name: $name');
    print('Height: $height');
    print('Weight: $weight');
    print('Age: $age');
    print('Sex: $sex');
    print('Blood Group: $bloodGroup');
    print('Relation : $relation');
    _addMember(parent_id);
  }

  Future<void> _addMember(String parent_id) async {
    String name = _nameController.text;
    String height = _heightController.text;
    String weight = _weightController.text;
    String age = _ageController.text;
    String sex = _selectedSex ?? 'Not Specified';
    String bloodGroup = _selectedBloodGroup ?? 'Not Specified';
    String relation = _selectedRelation ?? 'Not Specified';

    Map<String, dynamic> memberData = {
      'mem_name': name,
      'mem_height': height,
      'mem_weight': weight,
      'mem_age': age,
      'mem_sex': sex,
      'mem_blood_group': bloodGroup,
      'mem_relation': relation,
      'parent_id': parent_id,
    };
    //  parent_id, mem_name, mem_height, mem_weight, mem_blood_group, mem_age, mem_relation,mem_sex}

    final Uri apiUrl =
        Uri.parse('http://${ipconst.ipaddress}:3000/api/user/add-memeber');
    final response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(memberData),
    );

    if (response.statusCode == 200) {
      // Handle success response
      print('Member added successfully');
    } else {
      // Handle error response
      print('Failed to add member. Error: ${response.statusCode}');
    }
  }
}
