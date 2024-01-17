import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import 'package:flutter/material.dart';

class Myapp1 extends StatefulWidget {
  @override
  _Myapp1State createState() => _Myapp1State();
}

class _Myapp1State extends State<Myapp1> {
  File? imageFile;
  String? responseText;

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      setState(() {});
    }
  }

  Future<void> uploadImage() async {
    if (imageFile == null) return;

    final mimeType = lookupMimeType(imageFile!.path);
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.gemini.ai/v2/vision/text'),
    );
    final part = http.MultipartFile(
      'image',
      imageFile!.openRead(),
      imageFile!.length as int,
    );
    request.files.add(part);

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final decodedResponse = jsonDecode(responseData) as Map<String, dynamic>;
      responseText = decodedResponse['results'][0]['text'];
      setState(() {});
    } else {
      responseText = 'Error uploading image';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Image Upload & Gemini Text Recognition'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Pick Image'),
              ),
              if (imageFile != null) Image.file(imageFile!),
              if (responseText != null) Text(responseText!),
              ElevatedButton(
                onPressed: uploadImage,
                child: Text('Upload & Get Text'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
