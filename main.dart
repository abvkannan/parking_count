import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Upload Example',
      home: FileUploadScreen(),
    );
  }
}

class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  int freeSpaces = 0;

  Future<void> uploadFile() async {
    var url = Uri.parse('http://127.0.0.1:5000/parking_space_count');
    var request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file',
          "C:\\Users\\Abhinand v Kannan\\Desktop\\flut\\input_video.mp4"));

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var parsedResponse = jsonDecode(responseBody);
      setState(() {
        freeSpaces = parsedResponse['free_spaces'];
      });
      print('File uploaded successfully. Free spaces: $freeSpaces');
    } else {
      print('Failed to upload file: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Upload Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: uploadFile,
              child: Text('Upload File'),
            ),
            SizedBox(height: 20),
            Text(
              'Free Parking Spaces:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '$freeSpaces',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
