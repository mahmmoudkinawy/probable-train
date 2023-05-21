import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petscareclient/src/extensions/string_casing_extension.dart';
import 'package:petscareclient/src/models/user.dart';
import 'package:petscareclient/src/screens/home_screen.dart';
import 'package:petscareclient/src/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'aboutus_screen.dart';
import 'manage_clinics_screen.dart';
import 'privacy_policy_screen.dart';
import 'setting_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

bool _isTap = false;

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await getUser();
    setState(() {
      _user = user;
    });
  }

  Future<void> uploadImage() async {
    final user = await getUser();

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'http://pets-care.somee.com/api/users/add-image',
        ),
      );

      request.headers.addAll({'Authorization': 'Bearer ${user!.token}'});

      final file = File(pickedFile.path);
      final filename = file.path.split('/').last;
      final image = await http.MultipartFile.fromPath('imageFile', file.path,
          filename: filename);
      request.files.add(image);

      final response = await request.send();

      print('RESPONSE: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(await response.stream.bytesToString());
        print(jsonResponse);
      } else if (response.statusCode == 400) {
        Fluttertoast.showToast(
            msg: "Only JPEG and PNG files are allowed.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        print('Error uploading image: ${response.reasonPhrase}');
        print('Error uploading image: ${response.statusCode}');
        print(await response.stream.bytesToString());
      }
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
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Stack(
                  children: [
                    if (_user?.imageUrl != null)
                      Container(
                        margin: const EdgeInsets.all(5),
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                            image: NetworkImage(_user!.imageUrl!),
                            fit: BoxFit.cover, //change image fill type
                          ),
                        ),
                      )
                    else if (_user?.name != null)
                      Container(
                        margin: const EdgeInsets.all(5),
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey,
                        ),
                        child: Center(
                          child: Text(
                            _user!.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  _user!.name.toTitleCase(),
                  // capitalizeAllWord('ee'),
                  // _user!.name, // capitalize the first letter of each word
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                if (_user != null && _user!.roles.contains('Doctor'))
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
                            Icons.cabin,
                            color: Colors.blue.shade900,
                          ),
                          title: const Text('Manage Clinics'),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ManageClinicsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
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
                          Icons.privacy_tip,
                          color: Colors.blue.shade900,
                        ),
                        title: const Text('Privacy Policy'),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PrivacyPolicy()),
                          );
                        },
                      ),
                    ],
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
                          Icons.info,
                          color: Colors.blue.shade900,
                        ),
                        title: const Text('About Us'),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AboutUs()),
                          );
                        },
                      ),
                    ],
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
                          Icons.settings,
                          color: Colors.blue.shade900,
                        ),
                        title: const Text('Settings'),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () {
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
                          Icons.logout,
                          color: Colors.blue.shade900,
                        ),
                        title: const Text('Log Out'),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Navigate to search screen
              },
            ),
            IconButton(
              icon: Icon(Icons.person,
                  color: _isTap ? Colors.white : Colors.indigo),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
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
