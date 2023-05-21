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
      headers: {'Authorization': 'Bearer ${user!.token}'},
    );

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
          final disease = _diseasesData[index];
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ExpansionTile(
                title: Text(
                  disease.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                subtitle: Text(
                  'Tag: ${disease.tag}',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
                children: [
                  ListTile(
                    title: Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    subtitle: Text(
                      disease.description,
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Symptoms',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    subtitle: buildTextWithLineBreaks(disease.symptoms),
                  ),
                  ListTile(
                    title: Text(
                      'Causes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    subtitle: buildTextWithLineBreaks(disease.causes),
                  ),
                  ListTile(
                    title: Text(
                      'Treatment',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    subtitle: buildTextWithLineBreaks(disease.treatment),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildTextWithLineBreaks(String text) {
    final lines = text.split('\n');
    return Text(
      lines.join('\n'),
      style: TextStyle(
        fontSize: 14.0,
        color: Colors.grey[800],
      ),
    );
  }
}

class Disease {
  final String id;
  final String name;
  final String tag;
  final String description;
  final String symptoms;
  final String causes;
  final String treatment;

  Disease({
    required this.id,
    required this.name,
    required this.tag,
    required this.description,
    required this.symptoms,
    required this.causes,
    required this.treatment,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      tag: json['tag'] ?? '',
      description: json['description'] ?? '',
      symptoms: json['symptoms'] ?? '',
      causes: json['causes'] ?? '',
      treatment: json['treatment'] ?? '',
    );
  }
}
