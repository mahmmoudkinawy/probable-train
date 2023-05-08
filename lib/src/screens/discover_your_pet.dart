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
      Uri.parse('http://pets-care.somee.com/api/search/detect-data'),
    )
      ..headers.addAll({'Authorization': 'Bearer ${user!.token}'})
      ..files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final concepts = decodedResponse['concepts'] as List<dynamic>;
      final conceptNames =
          concepts.map((concept) => concept['name'] as String).toList();
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
                    Column(
                      children: _result!
                          .map((name) => Text(
                                name,
                                style: Theme.of(context).textTheme.headline6,
                              ))
                          .toList(),
                    ),
                ],
              ),
      ),
    );
  }
}
