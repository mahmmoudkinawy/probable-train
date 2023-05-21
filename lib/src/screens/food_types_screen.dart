import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class FoodTypesScreen extends StatefulWidget {
  @override
  _FoodTypesScreenState createState() => _FoodTypesScreenState();
}

class _FoodTypesScreenState extends State<FoodTypesScreen> {
  List foodTypes = [];

  Future fetchData() async {
    final user = await getUser();

    final response = await http.get(
        Uri.parse('http://10.0.2.2:5228/api/metadata/food-types'),
        headers: {'Authorization': 'Bearer ${user!.token}'});

    if (response.statusCode == 200) {
      setState(() {
        foodTypes = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Types'),
      ),
      body: ListView.builder(
        itemCount: foodTypes.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(foodTypes[index]['name']),
              subtitle: Text(foodTypes[index]['description']),
              leading: CircleAvatar(
                child: Text(foodTypes[index]['tag']),
                backgroundImage: NetworkImage(foodTypes[index]['imageUrl']),
              ),
            ),
          );
        },
      ),
    );
  }
}
