import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _results = [];

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String keyword) async {
    final user = await getUser();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5228/api/search?query=$keyword'),
      headers: {'Authorization': 'Bearer ${user?.token}'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResult = json.decode(response.body);
      final List<dynamic> results = [];

      for (final item in jsonResult) {
        if (item['fullName'] != null && item['specialty'] != null) {
          results.add(DoctorForSearch.fromJson(item));
        } else if (item['name'] != null && item['address'] != null) {
          results.add(ClinicForSearch.fromJson(item));
        } else if (item['name'] != null && item['breed'] != null) {
          results.add(AnimalForSearch.fromJson(item));
        }
      }

      setState(() {
        _results = results;
      });
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search in pets, doctors, clinics .... etc.',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            _search(value);
          },
        ),
      ),
      body: _results.isEmpty
          ? Center(child: Text('Search for something!'))
          : ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final result = _results[index];
                if (result is DoctorForSearch) {
                  return _buildDoctorCard(result);
                } else if (result is ClinicForSearch) {
                  return _buildClinicCard(result);
                } else if (result is AnimalForSearch) {
                  return _buildAnimalCard(result);
                } else {
                  return const SizedBox();
                }
              },
            ),
    );
  }

  Widget _buildDoctorCard(DoctorForSearch doctor) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.medical_services),
        title: Text(doctor.fullName ?? ''),
        subtitle: Text(doctor.specialty ?? ''),
      ),
    );
  }

  Widget _buildClinicCard(ClinicForSearch clinic) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.local_hospital_rounded, size: 50),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(clinic.name ?? '', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded, size: 18),
                      SizedBox(width: 5),
                      Text(clinic.address ?? ''),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.phone_rounded, size: 18),
                      SizedBox(width: 5),
                      Text(clinic.phoneNumber ?? ''),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 18),
                      SizedBox(width: 5),
                      Text(
                          'Opening hours: ${clinic.openingTime ?? ''} - ${clinic.closingTime ?? ''}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimalCard(AnimalForSearch animal) {
    return Card(
      child: ListTile(
        leading: Image.network(
          animal.imageUrl ?? '',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(animal.name ?? ''),
        subtitle: Text('${animal.breed ?? ''}, ${animal.age ?? ''} years old'),
      ),
    );
  }
}

class AnimalForSearch {
  final String? id;
  final String? name;
  final String? breed;
  final String? color;
  final String? notes;
  final String? imageUrl;
  final int? age;

  AnimalForSearch({
    this.id,
    this.name,
    this.breed,
    this.color,
    this.notes,
    this.imageUrl,
    this.age,
  });

  factory AnimalForSearch.fromJson(Map<String, dynamic> json) {
    return AnimalForSearch(
      id: json['id'],
      name: json['name'],
      breed: json['breed'],
      color: json['color'],
      notes: json['notes'],
      imageUrl: json['imageUrl'],
      age: json['age'],
    );
  }
}

class DoctorForSearch {
  final String? fullName;
  final String? specialty;
  final String? gender;
  final int? experience;
  final String? phoneNumber;
  final String? email;

  DoctorForSearch({
    this.fullName,
    this.specialty,
    this.gender,
    this.experience,
    this.phoneNumber,
    this.email,
  });

  factory DoctorForSearch.fromJson(Map<String, dynamic> json) {
    return DoctorForSearch(
      fullName: json['fullName'],
      specialty: json['specialty'],
      gender: json['gender'],
      experience: json['experience'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
    );
  }
}

class ClinicForSearch {
  final String? id;
  final String? name;
  final String? address;
  final String? phoneNumber;
  final String? openingTime;
  final String? closingTime;
  final String? userId;
  final UserForSearch? user;
  final List<AppointmentForSearch>? appointments;

  ClinicForSearch({
    this.id,
    this.name,
    this.address,
    this.phoneNumber,
    this.openingTime,
    this.closingTime,
    this.userId,
    this.user,
    this.appointments,
  });

  factory ClinicForSearch.fromJson(Map<String, dynamic> json) {
    final List<dynamic> appointmentsJson = json['appointments'] ?? [];
    final appointments = appointmentsJson
        .map((appointment) => AppointmentForSearch.fromJson(appointment))
        .toList();

    return ClinicForSearch(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      openingTime: json['openingTime'],
      closingTime: json['closingTime'],
      userId: json['userId'],
      user: json['user'] != null ? UserForSearch.fromJson(json['user']) : null,
      appointments: appointments,
    );
  }
}

class AppointmentForSearch {
  final String? id;
  final String? clinicId;
  final String? doctorId;
  final String? petId;
  final DateTime? date;

  AppointmentForSearch({
    this.id,
    this.clinicId,
    this.doctorId,
    this.petId,
    this.date,
  });

  factory AppointmentForSearch.fromJson(Map<String, dynamic> json) {
    return AppointmentForSearch(
      id: json['id'],
      clinicId: json['clinicId'],
      doctorId: json['doctorId'],
      petId: json['petId'],
      date: DateTime.tryParse(json['date']),
    );
  }
}

class UserForSearch {
  final String id;
  final String fullName;
  final String email;

  UserForSearch({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory UserForSearch.fromJson(Map<String, dynamic> json) {
    return UserForSearch(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
    );
  }
}
