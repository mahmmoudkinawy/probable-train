import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petscareclient/src/extensions/string_casing_extension.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import '../models/doctor_for_search.dart';
import '../models/user.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DoctorForSearch> _doctors = [];

  @override
  void initState() {
    super.initState();
    _searchDoctors('');
  }

  void _searchDoctors(String keyword) async {
    final user = await getUser();

    final response = await http.get(
        Uri.parse('http://pets-care.somee.com/api/doctors?Keyword=$keyword'),
        headers: {'Authorization': 'Bearer ${user!.token}'});

    if (response.statusCode == 200) {
      setState(() {
        _doctors = (json.decode(response.body) as List)
            .map((json) => DoctorForSearch.fromJson(json))
            .toList();
      });
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Search',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by name, specialty, or gender.',
              ),
              onSubmitted: (value) {
                _searchDoctors(value);
              },
            ),
            Expanded(
              child: _doctors.isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Uh-oh, it looks like our doctors are playing hide-and-seek. Let\'s try again with a different search criteria!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _doctors.length,
                      itemBuilder: (context, index) {
                        final doctor = _doctors[index];
                        return ListTile(
                          leading: FadeInImage.assetNetwork(
                            placeholder: 'assets/reload-cat.gif',
                            image: doctor.imageUrl,
                          ),
                          title: Text(
                            doctor.fullName.toTitleCase(),
                          ),
                          subtitle: Text(
                            doctor.specialty.toTitleCase(),
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              launch('tel:${doctor.phoneNumber}');
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Text(
                                doctor.phoneNumber,
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
