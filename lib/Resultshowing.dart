

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medical_app/Constants.dart';
import 'package:medical_app/HomeScreen.dart';
import 'package:medical_app/constants/ipaddress.dart';
import 'package:medical_app/memeber_response/datum.dart';
import 'package:medical_app/responseresult/responseresult.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MedicationPage extends StatefulWidget {
  final List<dynamic> jsonDataList;
  final File? imageFile;
  final int memid;
  final int parentid;
  final String keydescription;
  final String name;

  MedicationPage({
    required this.jsonDataList,
    required this.imageFile,
    required this.keydescription,
    required this.memid,
    required this.parentid,
    required this.name,
  });

  @override
  State<MedicationPage> createState() => _MedicationPageState();
}

List<dynamic>? hello;

class _MedicationPageState extends State<MedicationPage> {
  List<Responseresult> responseList = [];
  List? medications = hello;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    medications = List<Map<String, dynamic>>.from(widget.jsonDataList);
  }

  Future<void> sendPrescription() async {
    setState(() {
      isLoading = true;
    });

      final sharedpref = await SharedPreferences.getInstance();

String? storedEmail = sharedpref.getString('user_email');

    final url = 'http://${ipconst.ipaddress}:3000/api/user/add-prescription';

    final payload = {
      'profile_id': widget.parentid,
      'meme_id': widget.memid,
      'jsonresponse': widget.jsonDataList,
      'key_description': widget.keydescription,
    };

    try {
      // Show dialog with circular progress indicator
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      );

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      // Close the dialog
      // Navigator.pop(context);

      if (response.statusCode == 201) {
        // Handle success
        print('Prescription sent successfully');

        // Show an alert for 2 seconds
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Prescription sent successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to another page after 2 seconds
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>MyHomePage(userEmail: storedEmail!),
            ),
          );
        });
      } else {
        // Handle error
        print('Failed to send prescription. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send prescription'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      // Handle exceptions
      print('Error sending prescription: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending prescription'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(responseList);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorConst.Agreen,
        title: Text(
          'Medication Information',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(193, 100, 102, 100).withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Name: ${widget.name}',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 45,
                    columns: [
                      DataColumn(label: Text('S.No')),
                      DataColumn(label: Text('Medicine Name')),
                      DataColumn(label: Text('Dosage')),
                      DataColumn(label: Text('')),
                    ],
                    rows: List<DataRow>.generate(
                      medications!.length,
                      (index) {
                        final data = medications![index];
                        return DataRow(
                          cells: [
                            DataCell(Text((index + 1).toString())),
                            DataCell(
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(data['MedicineName'] ?? ''),
                                ],
                              ),
                            ),
                            DataCell(Text(data['Dosage'] ?? '')),
                            DataCell(Container()), // Empty cell for alignment
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {
            if (!isLoading) {
              sendPrescription();
            }
          },
          child: isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text('Verify Medication', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            primary: ColorConst.Agreen,
          ),
        ),
      ),
    );
  }
}