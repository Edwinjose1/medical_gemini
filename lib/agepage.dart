import 'package:flutter/material.dart';
import 'package:medical_app/Constants.dart';

class AgePage extends StatelessWidget {
  final Function(int) onNext;

  AgePage({required this.onNext});

  late String _enteredAge = ''; // Store entered text as a string

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Age'),
        backgroundColor: ColorConst.Agreen,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter Your Age',
              style: TextStyle(fontSize: 24.0, color: ColorConst.Agreen),
            ),
            SizedBox(height: 20.0),
            TextField(
              maxLength: 2,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter your age',
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _enteredAge = value; // Store entered text
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                int parsedAge =
                    int.tryParse(_enteredAge) ?? 0; // Parse text to integer
                onNext(parsedAge); // Pass the parsed age to the next page
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
