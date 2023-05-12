import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class DiseasesScreen extends StatefulWidget {
  @override
  _DiseasesScreenState createState() => _DiseasesScreenState();
}

class _DiseasesScreenState extends State<DiseasesScreen> {
  List _diseasesData = [];

  Future<List> fetchDiseasesData() async {
    final user = await getUser();

    final response = await http.get(
        Uri.parse('http://pets-care.somee.com/api/doctors'),
        headers: {'Authorization': 'Bearer ${user!.token}'});

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load diseases data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDiseasesData().then((value) {
      setState(() {
        _diseasesData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diseases Data'),
      ),
      body: ListView.builder(
        itemCount: _diseasesData.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_diseasesData[index]['name']),
            subtitle: Text(_diseasesData[index]['tag']),
            onTap: () {
              // Navigate to a new screen to display detailed information
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailedDiseaseScreen(disease: _diseasesData[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailedDiseaseScreen extends StatelessWidget {
  final Map disease;

  DetailedDiseaseScreen({required this.disease});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(disease['name']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(disease['description']),
            SizedBox(height: 16.0),
            Text(
              'Symptoms:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(disease['symptoms']),
            SizedBox(height: 16.0),
            Text(
              'Causes:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(disease['causes']),
            SizedBox(height: 16.0),
            Text(
              'Treatment:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(disease['treatment']),
          ],
        ),
      ),
    );
  }
}
