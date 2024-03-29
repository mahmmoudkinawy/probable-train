import 'package:flutter/material.dart';
import 'package:petscareclient/src/screens/chatbot_screen.dart';

import 'appointment_screen.dart';
import 'category_detail_screen.dart';
import 'clinics_screen.dart';
import 'discover_your_pet.dart';
import 'diseases_screen.dart';
import 'doctors_screen.dart';
import 'food_types_screen.dart';
import 'pets_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'setting_screen.dart';
import 'suppliers_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

bool _isTap = false;

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SafeArea(
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(10),
            children: [
              CategoryCard(
                title: 'Doctors',
                image: 'assets/doctors.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorsScreen(),
                    ),
                  );
                },
              ),
              CategoryCard(
                title: 'Clinics',
                image: 'assets/clinics.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ClinicsScreen()),
                  );
                },
              ),
              CategoryCard(
                title: 'Pets',
                image: 'assets/dog2.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PetsScreen(),
                    ),
                  );
                },
              ),
              CategoryCard(
                title: 'Appointment',
                image: 'assets/appointment.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppointmentScreen(),
                    ),
                  );
                },
              ),
              CategoryCard(
                title: 'Discover Your Pet',
                image: 'assets/your-pet.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DiscoverYourPetScreen(),
                    ),
                  );
                },
              ),
              CategoryCard(
                title: 'Chat',
                image: 'assets/chat.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatbotScreen(),
                    ),
                  );
                },
              ),
              CategoryCard(
                title: 'Diseases',
                image: 'assets/diseases.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiseasesScreen(),
                    ),
                  );
                },
              ),
              CategoryCard(
                title: 'Food Types',
                image: 'assets/dry-food.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodTypesScreen(),
                    ),
                  );
                },
              ),
              CategoryCard(
                title: 'Suppliers',
                image: 'assets/suppliers.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SuppliersScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: _isTap ? Colors.white : Colors.indigo,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.search,
              ),
              onPressed: () {
                // Navigate to search screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 90.0,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
