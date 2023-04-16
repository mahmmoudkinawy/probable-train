import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/pet.dart';
import '../models/user.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({Key? key}) : super(key: key);

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  List<Pet> _pets = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchPets();
  }

  Future<void> _fetchPets() async {
    final user = await getUser();

    final response = await http.get(
        Uri.parse('http://pets-care.somee.com/api/animals'),
        headers: {'Authorization': 'Bearer ${user!.token}'});

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        _pets = List<Pet>.from(jsonResponse.map((pet) => Pet.fromJson(pet)));
      });
    } else {
      throw Exception('Failed to fetch Pets');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pets.isEmpty) {
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
          'Available Pets In Our Clinic',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _pets.isNotEmpty
          ? CarouselSlider.builder(
              itemCount: _pets.length,
              options: CarouselOptions(
                height: 600,
                viewportFraction: 0.8,
                enableInfiniteScroll: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              itemBuilder: (BuildContext context, index, realIndex) {
                final pet = _pets[index];
                return Container(
                  margin: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Image.network(
                        pet.imageUrl,
                        height: 240.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pet.name,
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              '${pet.breed} - ${pet.age} years old',
                              style: const TextStyle(fontSize: 18.0),
                            ),
                            const SizedBox(height: 20.0),
                            Text(
                              pet.notes,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
