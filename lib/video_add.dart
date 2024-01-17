
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:google_gemini/google_gemini.dart';

import 'package:medical_app/Resultshowing.dart';
import 'package:medical_app/graph.dart';
import 'package:medical_app/memebers.dart';
import 'package:medical_app/symotms.dart';

import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final File? imageFile; // Add this line
  final int memid;
  final int parentid;
  final String keydescription;
  final String name;

  VideoPlayerScreen({required this.imageFile,required this.keydescription,required this.memid,required this.parentid,required this.name}); // Add

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  final Random _random = Random();
  

  String? generatedtext;

  bool _resultObtained = false; // Added variable

  List<String> videoPaths = [
    'lib/assets/videos/vid1.mp4',

    // Add more video paths as needed
  ];

  Future<void> _submit() async {
    print("hai");
    // Set loading state to true

    try {
      // Perform null check for _generateText method
      await _generateText();
    } finally {
      // Add a delay of 5 seconds
      await Future.delayed(Duration(seconds: 10));

      // Set loading state to false

      // Close the dialog only if data is available in generatedtext
      if (_resultObtained) {
        Navigator.of(context).pop();
      }
    }

    // Check if generatedtext has data
    if (generatedtext != null) {
      print('Generated Text: $generatedtext');

      // Navigate to the next page only if generatedtext has data
      if (_resultObtained) {
        navigateToNextScreen();
      } else {
        // Show a message or handle the case where generatedtext is empty
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Generated text is empty.'),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _submit();
    playRandomVideo();
  }

  void playRandomVideo() {
    String randomVideoPath = getRandomVideo();
    _videoPlayerController = VideoPlayerController.asset(randomVideoPath);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      // Other customization options can be added here
    );

    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.position ==
          _videoPlayerController.value.duration) {
        // Video playback completed
        navigateToNextScreen();
      }
    });
  }

  String getRandomVideo() {
    return videoPaths[_random.nextInt(videoPaths.length)];
  }

  void navigateToNextScreen() {
    // Replace this with your navigation logic to move to the next screen
    // For example:g
if (generatedtext == false) {

    dynamic jsonMap = json.decode(generatedtext!);
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => MedicationPage(
        jsonDataList: jsonMap,
        imageFile: widget.imageFile,
        keydescription: widget.keydescription,
        memid: widget.memid,
        name: widget.name,
        parentid: widget.parentid,
      ),
    ),
  );
 
} else {

   Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) =>UserDetailsScreen(),
    ),
  );
}

//     if("false"=="false")
//     {
//   Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (context) => MedicalReport())
//     );
//     }
//     else{
//           dynamic jsonMap = json.decode(generatedtext!);
// Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (context) => MedicationPage(jsonDataList:jsonMap,imageFile: widget.imageFile,keydescription:widget.keydescription,memid: widget.memid,name: widget.name,parentid: widget.parentid, ),
//       )
//     );
//     }
  
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Expanded(
          child: Chewie(
            controller: _chewieController,
          ),
        ),
      ),
    );
  }
Future<void> _generateText() async {
  if (widget.imageFile == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please select an image first.'),
      ),
    );
    return;
  }

  final apiKey = "AIzaSyCAvLHss4FX5gG08HYFtUcFNPpvurbpsYg";
  final gemini = GoogleGemini(apiKey: apiKey);
  final textPrompt =
      "If the user uploads an image that is a medical prescription, extract the  MedicineName, Dosage, from the image and output the information one medicine one after anoter in  json format in [ ]  just give the response and avoid using ``` and json. If the image is not a medical prescription, false. and don't respond with old information if it is give the staus as false";

  try {
    final value = await gemini.generateFromTextAndImages(
      query: textPrompt,
      image: widget.imageFile!,
    );

    

    // Check if the result is false and navigate to another page
   
    setState(() {
  generatedtext = value.text.toString();
  print(generatedtext);
  print(value.text);
  _resultObtained = true; // Set the result status to true
});

  } catch (e) {
    print(e);
    // Handle the error, you can show a message or navigate to another screen if needed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error generating text. Please try again.'),
      ),
    );
  }
}

}
