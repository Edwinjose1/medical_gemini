// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:medical_app/graph.dart';
// import 'dart:convert';

// import 'package:medical_app/memeber_response/datum.dart';

// class ListPage extends StatefulWidget {
//   final int id;

//   ListPage({required this.id});

//   @override
//   State<ListPage> createState() => _ListPageState();
// }

// class _ListPageState extends State<ListPage> {
//     bool isLoading = true;
//   final List<Datum> persons = [];


//   @override
//   void initState() {
//     super.initState();
//     fetchMembers(widget.id);
//   }

//   Future<void> fetchMembers(int Id) async {
//     final String apiUrl =
//         'http://192.168.1.41:3000/api/user/get-memeber?parent_id=$Id';

//     try {
//       var response = await http.get(Uri.parse(apiUrl));

//       if (response.statusCode == 200) {
//        setState(() {
//       isLoading =false;  // Set loading to true when starting to fetch data
//     });

//         var responseData = jsonDecode(response.body);

//         if (responseData['status'] == true) {
//           List<dynamic> membersData = responseData['data'];

//           setState(() {
//             persons.addAll(
//               membersData.map((member) {
//                 return Datum(
//                   memName: member['mem_name'],
//                   memAge: member['mem_age'],
//                   memRelation: member['mem_relation'],
//                   memSex: member['mem_sex'],
//                   memBloodGroup: member['mem_blood_group'],
//                   memHeight: member['mem_height'],
//                   memWeight: member['mem_weight'],
//                 );
//               }).toList(),
//             );
//           });
//         } else {
//           print('Query was not successful: ${responseData['message']}');
//         }
//       } else {
//         print('Failed to load data: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Error fetching data: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(persons[0].memName);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black, // App bar color black
//       ),
//       backgroundColor: Colors.black,
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: persons.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return InkWell(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => MedicalReport()));
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(8.0),
//                     margin: EdgeInsets.all(8.0),
//                     decoration: BoxDecoration(
//                       color: Colors.black,
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(
//                         15,
//                         0,
//                         0,
//                         0,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             height: 15,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 persons[index].memName!,
//                                 style: TextStyle(
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.w900,
//                                   color: Colors.white, // Text color white
//                                 ),
//                               ),
//                               Text(
//                                 'Blood: ${persons[index].memBloodGroup}',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 8.0),
//                           Row(
//                             children: [
//                               ClipOval(
//                                 child: Image.asset(
//                                   'lib/assets/images/proileIcon.png',
//                                   width: 80, // Adjust the size as needed
//                                   height: 80, // Adjust the size as needed
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               SizedBox(width: 15),
//                               Row(
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Age : ',
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                       SizedBox(
//                                         height: 8,
//                                       ),
//                                       Text(
//                                         'Relation : ',
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                       SizedBox(
//                                         height: 8,
//                                       ),
//                                       Text(
//                                         'Gender : ',
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                     ],
//                                   ),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         ' ${persons[index].memAge}',
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                       SizedBox(
//                                         height: 8,
//                                       ),
//                                       Text(
//                                         '${persons[index].memRelation}',
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                       SizedBox(
//                                         height: 8,
//                                       ),
//                                       Text(
//                                         '${persons[index].memSex}',
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 8.0),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Text('Details',
//                                   style: TextStyle(color: Colors.green)),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medical_app/constants/ipaddress.dart';
import 'package:medical_app/graph.dart';
import 'dart:convert';

import 'package:medical_app/memeber_response/datum.dart';

class ListPage extends StatefulWidget {
  final int id;

  ListPage({required this.id});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late Future<List<Datum>> membersFuture;

  @override
  void initState() {
    super.initState();
    membersFuture = fetchMembers(widget.id);
  }

  Future<List<Datum>> fetchMembers(int Id) async {
    final String apiUrl =
        'http://${ipconst.ipaddress}:3000/api/user/get-memeber?parent_id=$Id';

    try {
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          List<dynamic> membersData = responseData['data'];

          return membersData.map((member) {
            return Datum(
              memName: member['mem_name'],
              memAge: member['mem_age'],
              memRelation: member['mem_relation'],
              memSex: member['mem_sex'],
              memBloodGroup: member['mem_blood_group'],
              memHeight: member['mem_height'],
              memWeight: member['mem_weight'],
            );
          }).toList();
        } else {
          print('Query was not successful: ${responseData['message']}');
          throw Exception('Failed to load data');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
      throw Exception('Error fetching data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: membersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.red)),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Datum> persons = snapshot.data as List<Datum>;
            return ListView.builder(
              itemCount: persons.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MedicalReport()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        15,
                        0,
                        0,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                persons[index].memName!,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Blood: ${persons[index].memBloodGroup}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  'lib/assets/images/proileIcon.png',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 15),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Age : ',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'Relation : ',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'Gender : ',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ' ${persons[index].memAge}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        '${persons[index].memRelation}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        '${persons[index].memSex}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Details',
                                  style: TextStyle(color: Colors.green)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('No data available',
                  style: TextStyle(color: Colors.white)),
            );
          }
        },
      ),
    );
  }
}

