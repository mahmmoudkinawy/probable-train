import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:petscareclient/src/extensions/string_casing_extension.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/doctor.dart';
import '../models/user.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final Doctor doctor;

  DoctorDetailsScreen({required this.doctor});

  @override
  _DoctorDetailsScreenState createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  Doctor? _fetchedDoctor;

  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails(widget.doctor.id);
  }

  Future<void> _fetchDoctorDetails(String id) async {
    final user = await getUser();

    final response = await http.get(
        Uri.parse('http://pets-care.somee.com/api/doctors/${id}'),
        headers: {'Authorization': 'Bearer ${user!.token}'});

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        _fetchedDoctor = Doctor.fromJson(responseData);
      });
    } else {
      print('Faild to load the user from the API.');
    }
  }

  void _launchPhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Doctor doctor = _fetchedDoctor ?? widget.doctor;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      doctor.imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.pop(context),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            doctor.fullName.toTitleCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            doctor.specialty,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDoctorInfo('Gender', doctor.gender),
                              _buildDoctorInfo(
                                  'Experience', '${doctor.experience} years'),
                              GestureDetector(
                                onTap: () {
                                  launch("tel:${doctor.phoneNumber}");
                                },
                                child: _buildDoctorInfo(
                                    'Phone Number', doctor.phoneNumber),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    ).paddingOnly(right: 8, left: 8);
  }
}
