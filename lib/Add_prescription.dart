
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medical_app/Constants.dart';
import 'package:medical_app/constants/ipaddress.dart';
import 'package:medical_app/video_add.dart';
import 'memeber_response/datum.dart';

class ProfileSelectionAndImageUploadPage extends StatefulWidget {
  final int id;

  ProfileSelectionAndImageUploadPage({required this.id});
  @override
  _ProfileSelectionAndImageUploadPageState createState() =>
      _ProfileSelectionAndImageUploadPageState();
}

class _ProfileSelectionAndImageUploadPageState
    extends State<ProfileSelectionAndImageUploadPage> {
  final ImagePicker picker = ImagePicker();
  File? _imageFile;
  String? _selectedProfileName;
  String? _whyPrescribedFor;
  bool _resultObtained = false;
  final List<Datum> persons = []; // List to store person data
  Datum? selectedPerson; // Variable to store the selected person
  final TextEditingController _prescriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchMembers(widget.id);
  }

  Future<void> fetchMembers(int parentId) async {
    final String apiUrl =
        'http://${ipconst.ipaddress}:3000/api/user/get-memeber?parent_id=$parentId';

    try {
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          List<dynamic> membersData = responseData['data'];

          setState(() {
            persons.addAll(
              membersData.map((member) {
                return Datum(
                  memId: member['mem_id'],
                  memName: member['mem_name'],
                  memAge: member['mem_age'],
                  memRelation: member['mem_relation'],
                  memSex: member['mem_sex'],
                  memBloodGroup: member['mem_blood_group'],
                  memHeight: member['mem_height'],
                  memWeight: member['mem_weight'],
                );
              }).toList(),
            );
          });
        } else {
          print('Query was not successful: ${responseData['message']}');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Profile and Image',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorConst.Agreen,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  
                  child: TextFormField(
                      controller: _prescriptionController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Why you prescribed for........',
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorConst.Agreen, width: 2.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _whyPrescribedFor = value;
                    },
                  ),
                ),
                SizedBox(height: 20),
           Padding(
  padding: const EdgeInsets.symmetric(horizontal: 30),
 child: Container(
  height: 50,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: Colors.grey,
      width: 1.0,
    ),
  ),
  child: Align(
    alignment: Alignment.center,
    child: DropdownButtonFormField<Datum>(
      value: selectedPerson,
      hint: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          'Select Profile Name',
          style: TextStyle(color: ColorConst.Agreen),
        ),
      ),
      onChanged: (Datum? newValue) {
        setState(() {
          selectedPerson = newValue;
          _selectedProfileName = newValue?.memName;
          _resultObtained = false;
        });
      },
      items: persons.map<DropdownMenuItem<Datum>>((Datum value) {
        return DropdownMenuItem<Datum>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              value.memName ?? '',
              style: TextStyle(color: ColorConst.Agreen),
            ),
          ),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select a profile';
        }
        return null;
      },
      decoration: InputDecoration.collapsed(
        hintText: '',
      ),
    ),
  ),
),

),

                SizedBox(height: 20),
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 1, color: const Color.fromARGB(255, 122, 124, 122)),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _imageFile == null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'lib/assets/images/preview.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(_imageFile!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                      if (_imageFile != null)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: InkWell(
                            onTap: _cancelImage,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                if (_imageFile != null)
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        int memId = selectedPerson?.memId ?? 0;
                        String name = selectedPerson?.memName ?? "NO Name";
                        print(memId);
                        print(widget.id);
                        print(_prescriptionController.text);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VideoPlayerScreen(imageFile: _imageFile!,keydescription: _prescriptionController.text,memid: memId,parentid: widget.id,name: name),
                          ),
                        );
                      }
                    },
                    child: Text('Submit', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      primary: ColorConst.Agreen,
                    ),
                  ),
                if (_imageFile == null)
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: Text('Gallery', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      primary: ColorConst.Agreen,
                    ),
                  ),
                if (_imageFile == null)
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: Text('Camera', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      primary: ColorConst.Agreen,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _resultObtained = false;
      } else {
        print('No image selected.');
      }
    });
  }

  void _cancelImage() {
    setState(() {
      _imageFile = null;
      _resultObtained = false;
    });
  }
}
