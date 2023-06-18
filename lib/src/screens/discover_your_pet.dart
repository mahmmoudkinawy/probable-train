import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/user.dart';

class DiscoverYourPetScreen extends StatefulWidget {
  const DiscoverYourPetScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverYourPetScreen> createState() => _DiscoverYourPetScreenState();
}

class _DiscoverYourPetScreenState extends State<DiscoverYourPetScreen> {
  File? _imageFile;
  List<String>? _result;

  Future<void> _selectAndSendImage() async {
    final user = await getUser();

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select an image first.'),
        ),
      );
      return;
    }

    // Send the image to the API
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:5228/api/search/detect-data'),
    )
      ..headers.addAll({'Authorization': 'Bearer ${user!.token}'})
      ..files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      print('DATA BACK:=>' + response.body);

      final conceptNames = List<String>.from(jsonDecode(response.body));

      print('API Data => $conceptNames');
      setState(() {
        _result = conceptNames;
      });
    } else {
      print('Failed to upload image: ${response.statusCode}');
    }
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _imageFile = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Your Pet'),
      ),
      body: Center(
        child: _imageFile == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Select an image to discover your pet'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Upload Image'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(_imageFile!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _selectAndSendImage,
                    child: const Text('Discover'),
                  ),
                  const SizedBox(height: 16),
                  if (_result != null)
                    Expanded(
                      child: ListView.builder(
                        itemCount: _result!.length,
                        itemBuilder: (context, index) {
                          final concept = _result![index];
                          return ListTile(
                            title: Text(concept),
                            trailing: const Icon(Icons.pets),
                          );
                        },
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
