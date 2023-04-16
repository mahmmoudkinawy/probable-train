import 'package:flutter/material.dart';

import 'package:petscareclient/src/screens/home_screen.dart';

import 'profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

bool _isTap = false;

class _SettingsScreenState extends State<SettingsScreen> {
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
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Common",
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.fromLTRB(5, 8, 5, 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.language,
                      color: Colors.blue.shade900,
                    ),
                    title: const Text('Language'),
                    trailing: const Text(
                      "English",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.devices,
                      color: Colors.blue.shade900,
                    ),
                    title: const Text(
                      'Platform',
                    ),
                    trailing: const Text(
                      "Android",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                  SwitchListTile(
                      activeColor: Colors.grey,
                      secondary: Icon(
                        Icons.format_paint,
                        color: Colors.blue.shade900,
                      ),
                      title: const Text('Enable Custom Theme'),
                      value: false,
                      onChanged: (bool value) {}),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                "Contact Us",
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.fromLTRB(5, 8, 5, 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Colors.blue.shade900,
                    ),
                    title: const Text('Phone Number'),
                    subtitle: const Text(
                      "01271128361",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.email,
                      color: Colors.blue.shade900,
                    ),
                    title: const Text('Email'),
                    subtitle: const Text(
                      "pets-care@support.com",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Security - Coming Soon",
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.fromLTRB(5, 8, 5, 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                      activeColor: Colors.grey,
                      secondary: Icon(
                        Icons.screen_lock_portrait_sharp,
                        color: Colors.blue.shade900,
                      ),
                      title: const Text(
                        'Lock app in packground',
                        style: TextStyle(fontSize: 14),
                      ),
                      value: true,
                      onChanged: (bool value) {}),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                  SwitchListTile(
                      activeColor: Colors.grey,
                      secondary: Icon(
                        Icons.fingerprint,
                        color: Colors.blue.shade900,
                      ),
                      title: const Text('Use fingerprint'),
                      value: true,
                      onChanged: (bool value) {}),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Navigate to search screen
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
              icon: Icon(Icons.settings,
                  color: _isTap ? Colors.white : Colors.indigo),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
