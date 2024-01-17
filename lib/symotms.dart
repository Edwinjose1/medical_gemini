import 'package:flutter/material.dart';
import 'package:medical_app/Constants.dart';

class UserDetailsScreen extends StatefulWidget {
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late PageController _pageController;
  late TextEditingController _medicineSymptomsController;
  late TextEditingController _durationController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _medicineSymptomsController = TextEditingController();
    _durationController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _medicineSymptomsController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPageIndex < 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      setState(() {
        _currentPageIndex++;
      });
    }
  }

  void _saveAndNavigateToHome() {
    // Add your logic to save data to the server
    // For now, let's print the entered data
    print('Medicine Symptoms: ${_medicineSymptomsController.text}');
    print('Duration: ${_durationController.text}');

    // Navigate to the home screen or the next screen
    // Replace with your navigation logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.Agreen,
        title: Text('User Details Setup'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          // Page 1: Medicine Symptoms Input
          buildPage(
            title: 'Step 1 of 2',
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter medicine symptoms',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _medicineSymptomsController,
                  decoration: InputDecoration(
                    labelText: 'Medicine Symptoms',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text('Next', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    primary: ColorConst.Agreen,
                  ),
                ),
              ],
            ),
          ),
          // Page 2: Duration Input
          buildPage(
            title: 'Step 2 of 2',
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter duration',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _durationController,
                  decoration: InputDecoration(
                    labelText: 'Duration',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveAndNavigateToHome,
                  child: Text('Finish', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    primary: ColorConst.Agreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage({required String title, required Widget content}) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          content,
        ],
      ),
    );
  }
}
