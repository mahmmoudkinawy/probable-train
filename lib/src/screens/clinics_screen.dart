import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:petscareclient/src/extensions/string_casing_extension.dart';

class ClinicsScreen extends StatefulWidget {
  const ClinicsScreen({super.key});

  @override
  State<ClinicsScreen> createState() => _ClinicsScreenState();
}

class _ClinicsScreenState extends State<ClinicsScreen> {
  List<dynamic> _clinics = [];

  @override
  void initState() {
    super.initState();
    _fetchClinics();
  }

  Future<void> _fetchClinics() async {
    final user = await getUser();

    final response = await http.get(
        Uri.parse('http://pets-care.somee.com/api/clinics'),
        headers: {'Authorization': 'Bearer ${user!.token}'});

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        _clinics = jsonResponse;
      });
    } else {
      throw Exception('Failed to fetch clinics');
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_clinics.isEmpty) {
      return Container(
        color: Colors.blueGrey.shade200, // set your desired background color here
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Colors.blue), // set your desired color for the spinner
            strokeWidth: 3, // set the width of the spinner
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.grey.shade200,
        title: const Text(
          'Clinics',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _clinics.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _clinics.length,
              itemBuilder: (BuildContext context, int index) {
                final clinic = _clinics[index];

                final openingTime =
                    DateFormat('HH:mm:ss').parse(clinic['openingTime']);
                final closingTime =
                    DateFormat('HH:mm:ss').parse(clinic['closingTime']);

                final formattedOpeningTime =
                    DateFormat('h:mm a').format(openingTime);
                final formattedClosingTime =
                    DateFormat('h:mm a').format(closingTime);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    margin: const EdgeInsets.fromLTRB(5, 8, 5, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            '${clinic['name']}'.toTitleCase(),
                          ),
                          subtitle: Text(
                            '${clinic['address']}'.toTitleCase(),
                          ),
                          trailing: InkWell(
                            onTap: () {
                              launch('tel:${clinic['phoneNumber']}');
                            },
                            child: Text(
                              clinic['phoneNumber'],
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                'Opening time: $formattedOpeningTime',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Closing time: $formattedClosingTime',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
