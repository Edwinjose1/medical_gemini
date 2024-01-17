import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:medical_app/Add_prescription.dart';
import 'package:medical_app/Constants.dart';
import 'dart:convert';

import 'package:medical_app/Create_member.dart';
import 'package:medical_app/constants/ipaddress.dart';
import 'package:medical_app/main.dart';
import 'package:medical_app/memebers.dart';
import 'package:medical_app/profile.dart';
import 'package:medical_app/profile/datum.response.dart';
import 'package:medical_app/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  final String userEmail;

  MyHomePage({required this.userEmail});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true; // To track loading state
  List<Datum> userData = [];

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch data when the app starts
  }

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://${ipconst.ipaddress}:3000/api/user/get-user-email?email=${widget.userEmail}'));

      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);
        print(jsonData);

        if (jsonData['status'] == true) {
          final List<dynamic> usersData = jsonData['data'];

          List<Datum> users =
              usersData.map((userJson) => Datum.fromJson(userJson)).toList();
          print("asdfasfasa$users");

          setState(() {
            print("asdfasfasa$users");
            userData = users;
            print(userData);
            isLoading = false; // Update loading state when data is fetched
          });
        } else {
          print('Query was not successful: ${jsonData['message']}');
          isLoading = false; // Update loading state on failure
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
        isLoading = false; // Update loading state on failure
      }
    } catch (error) {
      print('Error fetching data: $error');
      isLoading = false; // Update loading state on error
    }
  }

  @override
  Widget build(BuildContext context) {
    print("asdfasfasa$userData");
    return Scaffold(
      drawer: DDrawer(
        id: userData.isNotEmpty ? userData[0].id! : 0,
        context: context,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.only(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: ColorConst.Agreen,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          ),
                          height: 250.0,
                          width: double.infinity,
                        ),
                        Positioned(
                          bottom: 50.0,
                          right: 100.0,
                          child: Container(
                            height: 400.0,
                            width: 400.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(200.0),
                              color: const Color.fromARGB(136, 0, 0, 0)
                                  .withOpacity(0.4),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 100.0,
                          left: 150.0,
                          child: Container(
                            height: 300.0,
                            width: 300.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(150.0),
                              color: Colors.black38.withOpacity(0.5),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 15.0),
                            Row(
                              children: <Widget>[
                                SizedBox(width: 15.0),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width -
                                        120.0),
                              ],
                            ),
                            SizedBox(height: 80.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    'Hey ${userData[0].userName!.toUpperCase()}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Quicksand',
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          top: 50,
                          right: 30.0,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileCreationPage(
                                          userEmail: widget.userEmail,
                                        )),
                              );
                            },
                            child: Container(
                              height: 45.0,
                              width: 45.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(200.0),
                                color: const Color.fromARGB(255, 243, 242, 240),
                                image: DecorationImage(
                                  image: AssetImage(
                                      'lib/assets/images/proileIcon.png'), // Replace with your image path
                                  fit: BoxFit.cover, // Adjust the fit as needed
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
     Padding(
  padding: const EdgeInsets.all(30),
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
    padding: EdgeInsets.only(left: 15, right: 15),
    height: 400,
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 25),
        Row(
          children: [
            Text(
              'Name:',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            userData.isNotEmpty
                ? Text(
                    ' ${userData[0].userName!.toUpperCase() ?? 'Update'}',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : Text(
                    ' Update',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ],
        ),
        SizedBox(height: 25),
        Row(
          children: [
            Text(
              'Email:',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            userData.isNotEmpty
                ? Expanded(
                  child: Text(
                      ' ${userData[0].userEmail ?? 'No Data'}',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 13 ,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                )
                : Text(
                    ' No Data',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ],
        ),
        SizedBox(height: 25),
        Row(
          children: [
            Text(
              'Age:',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            userData.isNotEmpty
                ? Text(
                    ' ${userData[0].userAge?.toString() ?? 'Update'}',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : Text(
                    ' Update',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ],
        ),
        SizedBox(height: 25),
        Row(
          children: [
            Text(
              'Sex:',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            userData.isNotEmpty
                ? Text(
                    ' ${userData[0].userSex ?? 'No Data'}',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : Text(
                    ' No Data',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ],
        ),
      ],
    ),
  ),
),


                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    ColorConst.Agreen)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileSelectionAndImageUploadPage( id: userData.isNotEmpty ? userData[0].id! : 0,)),
                              );
                            },
                            child: Text(
                              "Add Prescription",
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConst.Agreen,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileForm(
                      parent_id: userData[0].id.toString(),
                    )),
          );
        },
      ),
    );
  }
}

class DDrawer extends StatelessWidget {
  final int id;
  final BuildContext context;
  DDrawer({required this.id, required this.context});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: ColorConst.Agreen,
            ),
            child: Text(
              'DETAILS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          SizedBox(
            height: 70,
          ),
          ListTile(
            trailing: Icon(Icons.person),
            title: Text(
              'Members',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              // Add your logic here for ListTile 1
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListPage(id: id),
                  )); // Close the drawer
            },
          ),
          ListTile(
            trailing: Icon(Icons.logout),
            title: Text('Log out', style: TextStyle(fontSize: 20)),
            onTap: () {
              signOut();
              // Add your logic here for ListTile 2
              // Close the drawer
            },
          ),
        ],
      ),
    );
  }

  Future<void> signOut() async {
    // Get the SharedPreferences instance
    final sharedpref = await SharedPreferences.getInstance();
    await sharedpref.setBool(SAVE_KEY_NAME, false);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignUpPage(),
        ));

    // Add any other necessary clearances

    print('Signed out successfully');
  }
}
