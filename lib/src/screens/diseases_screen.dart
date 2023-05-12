import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class DiseasesScreen extends StatefulWidget {
  @override
  _DiseasesScreenState createState() => _DiseasesScreenState();
}

class _DiseasesScreenState extends State<DiseasesScreen> {
  List<Disease> _diseasesData = [];

  Future<List<Disease>> fetchDiseasesData() async {
    final user = await getUser();

    final response = await http.get(
        Uri.parse('http://pets-care.somee.com/api/metadata/diseases'),
        headers: {'Authorization': 'Bearer ${user!.token}'});

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('DATA ${response.body}');
      return data.map((json) => Disease.fromJson(json)).toList();
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
            title: Text(_diseasesData[index].name),
            subtitle: Text(_diseasesData[index].tag),
            onTap: () {
              // Navigate to a new screen to display detailed information
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailedDiseaseScreen(
                      disease: _diseasesData[index].toMap()),
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
            Text.rich(
              TextSpan(
                text: 'Treatment:',
                style: TextStyle(fontWeight: FontWeight.bold),
                children: [
                  for (String treatment in disease['treatment'].split('\n'))
                    TextSpan(
                      text: treatment,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Disease {
  final String name;
  final String tag;
  final String description;
  final String symptoms;
  final String causes;
  final String treatment;

  Disease({
    required this.name,
    required this.tag,
    required this.description,
    required this.symptoms,
    required this.causes,
    required this.treatment,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      name: json['name'],
      tag: json['tag'],
      description: json['description'],
      symptoms: json['symptoms'],
      causes: json['causes'],
      treatment: json['treatment'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'tag': tag,
      'description': description,
      'symptoms': symptoms,
      'causes': causes,
      'treatment': treatment,
    };
  }
}
