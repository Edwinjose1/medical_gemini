import 'package:flutter/material.dart';
import 'package:medical_app/Constants.dart';

class SexPage extends StatefulWidget {
  final Function(String) onNext;
  final String? selectedSex; // Make selectedSex an optional named parameter

  SexPage({required this.onNext, this.selectedSex}); // Update the constructor

  @override
  _SexPageState createState() => _SexPageState();
}

class _SexPageState extends State<SexPage> {
  late String selectedSex;

  @override
  void initState() {
    super.initState();
    selectedSex = widget.selectedSex ??
        ''; // Initialize with provided value or empty string
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sex'),
        backgroundColor: ColorConst.Agreen,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select Your Gender',
              style: TextStyle(fontSize: 24.0, color: ColorConst.Agreen),
            ),
            SizedBox(height: 20.0),
            ListTile(
              title: Text('Male'),
              leading: Radio(
                value: 'Male',
                groupValue: selectedSex,
                onChanged: (value) {
                  setState(() {
                    selectedSex = value.toString();
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Female'),
              leading: Radio(
                value: 'Female',
                groupValue: selectedSex,
                onChanged: (value) {
                  setState(() {
                    selectedSex = value.toString();
                  });
                },
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                widget.onNext(
                    selectedSex); // Pass the selected sex to the next page
              },
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                primary: ColorConst.Agreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
