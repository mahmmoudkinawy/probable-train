import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petscareclient/src/extensions/string_casing_extension.dart';

import '../models/doctor.dart';
import '../models/user.dart';
import 'doctor_details_screen.dart';

class DoctorsScreen extends StatefulWidget {
  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  List<Doctor> _doctors = [];

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  void _fetchDoctors() async {
    final user = await getUser();

    final response = await http.get(
        Uri.parse('http://pets-care.somee.com/api/doctors'),
        headers: {'Authorization': 'Bearer ${user!.token}'});

    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body) as List;
      final doctorsList =
          jsonList.map((json) => Doctor.fromJson(json)).toList();
      setState(() {
        _doctors = doctorsList;
      });
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_doctors.isEmpty) {
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
      backgroundColor: Colors.grey[200],
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
            'Available Doctors',
            style: TextStyle(color: Colors.black),
          ),
        ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8,
              children: _doctors.map(
                (doctor) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DoctorDetailsScreen(doctor: doctor),
                        ),
                      );
                    },
                    child: FutureBuilder(
                      future: precacheImage(
                          NetworkImage(doctor.imageUrl!), context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Card(
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(4),
                                    ),
                                    child: Image.network(
                                      doctor.imageUrl!,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doctor.fullName.toTitleCase(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        doctor.specialty,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Card(
                            elevation: 2,
                            child: Container(
                              height: 200,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
