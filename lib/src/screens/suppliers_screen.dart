import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class SuppliersScreen extends StatefulWidget {
  @override
  _SuppliersScreenState createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  List suppliers = [];

  Future fetchData() async {
    final user = await getUser();

    final response = await http.get(
      Uri.parse('http://10.0.2.2:5228/api/metadata/suppliers'),
      headers: {'Authorization': 'Bearer ${user!.token}'},
    );

    if (response.statusCode == 200) {
      setState(() {
        suppliers = json.decode(response.body);
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
        title: const Text('Suppliers'),
      ),
      body: ListView.builder(
        itemCount: suppliers.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(suppliers[index]['name']),
              subtitle: Text(suppliers[index]['description']),
              leading: CircleAvatar(
                child: Text(suppliers[index]['tag']),
                backgroundImage: NetworkImage(suppliers[index]['imageUrl']),
              ),
            ),
          );
        },
      ),
    );
  }
}
