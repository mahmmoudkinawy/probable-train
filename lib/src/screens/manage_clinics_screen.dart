import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/clinic.dart';
import '../models/user.dart';

class ManageClinicsScreen extends StatefulWidget {
  const ManageClinicsScreen({Key? key}) : super(key: key);

  @override
  _ManageClinicsScreenState createState() => _ManageClinicsScreenState();
}

class _ManageClinicsScreenState extends State<ManageClinicsScreen> {
  List<Clinic> _clinics = [];

  @override
  void initState() {
    super.initState();
    _fetchClinics();
  }

  Future<void> _fetchClinics() async {
    final user = await getUser();

    final response = await http.get(
      Uri.parse('http://pets-care.somee.com/api/clinics/current-user-clinics'),
      headers: {'Authorization': 'Bearer ${user!.token}'},
    );

    if (response.statusCode == 200) {
      final clinicsJson = jsonDecode(response.body) as List<dynamic>;
      ;
      final clinics = clinicsJson.map((json) => Clinic.fromJson(json)).toList();
      setState(() {
        _clinics = clinics;
      });
    } else {
      print('Failed to fetch clinics. Response: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to fetch clinics');
    }
  }

  Future<void> _deleteClinic(int clinicId) async {
    final user = await getUser();

    final response = await http.delete(
      Uri.parse('http://pets-care.somee.com/api/clinics/$clinicId'),
      headers: {'Authorization': 'Bearer ${user!.token}'},
    );

    if (response.statusCode == 204) {
      // Clinic deleted successfully
      setState(() {
        _clinics.removeWhere((clinic) => clinic.id == clinicId);
      });
    } else {
      // Failed to delete clinic
      throw Exception('Failed to delete clinic');
    }
  }

  Future<void> _confirmDeleteClinic(int clinicId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this clinic?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _deleteClinic(clinicId);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete clinic')),
        );
      }
    }
  }

  Future<void> _createClinic() async {
    final _formKey = GlobalKey<FormBuilderState>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Clinic'),
        content: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'name',
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.maxLength(50),
                    FormBuilderValidators.minLength(3),
                  ]),
                ),
                const SizedBox(
                  height: 5,
                ),
                FormBuilderTextField(
                  name: 'address',
                  decoration: const InputDecoration(
                    labelText: 'Address',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.maxLength(100),
                    FormBuilderValidators.minLength(5),
                  ]),
                ),
                const SizedBox(
                  height: 5,
                ),
                FormBuilderTextField(
                  name: 'phoneNumber',
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: 'Phone Number is required.'),
                    FormBuilderValidators.match(
                      r"^01[0-2,5]{1}[0-9]{8}$",
                      errorText: "Enter a valid Egyptian Phone Number.",
                    )
                  ]),
                ),
                const SizedBox(
                  height: 5,
                ),
                FormBuilderDateTimePicker(
                  name: 'openingTime',
                  inputType: InputType.time,
                  format: DateFormat('h:mm a'),
                  decoration: const InputDecoration(
                    labelText: 'Opening Time',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const SizedBox(
                  height: 5,
                ),
                FormBuilderDateTimePicker(
                  name: 'closingTime',
                  inputType: InputType.time,
                  format: DateFormat('h:mm a'),
                  decoration: const InputDecoration(
                    labelText: 'Closing Time',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              print('Sunmtting data');
              if (_formKey.currentState!.validate()) {
                final openingTime = _formKey
                    .currentState!.fields['openingTime']!.value as DateTime;
                final closingTime = _formKey
                    .currentState!.fields['closingTime']!.value as DateTime;

                if (closingTime.isBefore(openingTime)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                      'Closing time must be greater than opening time.',
                    )),
                  );
                } else {
                  final openingTime = _formKey
                      .currentState!.fields['openingTime']!.value as DateTime;
                  final closingTime = _formKey
                      .currentState!.fields['closingTime']!.value as DateTime;

                  final openingTimeString =
                      DateFormat('HH:mm:ss').format(openingTime.toLocal());
                  final closingTimeString =
                      DateFormat('HH:mm:ss').format(closingTime.toLocal());

                  final Clinic newClinic = Clinic(
                      id:
                          '687fe318-d3a4-4a15-afd7-f5af860d009c', // Set to a negative number to indicate a new clinic
                      name: _formKey.currentState!.fields['name']!.value
                          as String,
                      address: _formKey.currentState!.fields['address']!.value
                          as String,
                      phoneNumber: _formKey
                          .currentState!.fields['phoneNumber']!.value as String,
                      openingTime: openingTimeString,
                      closingTime: closingTimeString,
                      clinicOwnerId: '687fe318-d3a4-4a15-afd7-f5af860d009c');

                  Navigator.pop(context, true);
                  setState(() {
                    _clinics.add(newClinic);
                  });
                }
              }
            },
            child: const Text(
              'Add',
            ),
          ),
        ],
      ),
    );

    // If the user submitted the clinic data, send it to the API
    if (confirmed == true) {
      final user = await getUser();

      final openingTime =
          _formKey.currentState!.fields['openingTime']!.value as DateTime;
      final closingTime =
          _formKey.currentState!.fields['closingTime']!.value as DateTime;

      final openingTimeString =
          DateFormat('HH:mm:ss').format(openingTime.toLocal());
      final closingTimeString =
          DateFormat('HH:mm:ss').format(closingTime.toLocal());

      final response = await http.post(
        Uri.parse('http://pets-care.somee.com/api/clinics'),
        headers: {
          'Authorization': 'Bearer ${user!.token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'name': _formKey.currentState!.fields['name']!.value,
          'address': _formKey.currentState!.fields['address']!.value,
          'phoneNumber': _formKey.currentState!.fields['phoneNumber']!.value,
          'openingTime': openingTimeString,
          'closingTime': closingTimeString,
        }),
      );

      if (response.statusCode == 200) {
        final clinicJson = jsonDecode(response.body) as Map<String, dynamic>;
        final clinic = Clinic.fromJson(clinicJson);
        setState(() {
          _clinics.add(clinic);
          _fetchClinics();
        });
      } else {
        throw Exception('Failed to create clinic');
      }
    }
  }

  Future<void> _updateClinicName(Clinic clinic) async {
    TimeOfDay? openingTime = TimeOfDay.fromDateTime(
      DateFormat('HH:mm').parse(clinic.openingTime),
    );
    TimeOfDay? closingTime = TimeOfDay.fromDateTime(
      DateFormat('HH:mm').parse(clinic.closingTime),
    );
    final _formKey = GlobalKey<FormBuilderState>();
    String? updatedClinicName = clinic.name;
    String? updatedClinicAddress = clinic.address;
    String? updatedClinicPhoneNumber = clinic.phoneNumber;
    TimeOfDay? updatedClinicOpeningTime = openingTime;
    TimeOfDay? updatedClinicClosingTime = closingTime;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Clinic Information'),
          content: FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormBuilderTextField(
                  name: 'name',
                  initialValue: clinic.name,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.maxLength(50),
                    FormBuilderValidators.minLength(3),
                  ]),
                  onChanged: (value) => updatedClinicName = value,
                ),
                FormBuilderTextField(
                  name: 'address',
                  initialValue: clinic.address,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.maxLength(100),
                    FormBuilderValidators.minLength(5),
                  ]),
                  onChanged: (value) => updatedClinicAddress = value,
                ),
                FormBuilderTextField(
                  name: 'phoneNumber',
                  initialValue: clinic.phoneNumber,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                    FormBuilderValidators.minLength(10),
                    FormBuilderValidators.maxLength(15),
                  ]),
                  onChanged: (value) => updatedClinicPhoneNumber = value,
                ),
                FormBuilderDateTimePicker(
                  name: 'openingTime',
                  initialTime: openingTime,
                  inputType: InputType.time,
                  format: DateFormat('HH:mm'),
                  decoration: const InputDecoration(
                    labelText: 'Opening Time',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  onChanged: (value) =>
                      updatedClinicOpeningTime = TimeOfDay.fromDateTime(value!),
                ),
                FormBuilderDateTimePicker(
                  name: 'closingTime',
                  initialTime: closingTime,
                  inputType: InputType.time,
                  format: DateFormat('HH:mm'),
                  decoration: const InputDecoration(
                    labelText: 'Closing Time',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  onChanged: (value) =>
                      updatedClinicOpeningTime = TimeOfDay.fromDateTime(value!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.saveAndValidate()) {
                  final user = await getUser();
                  final updatedClinic = Clinic(
                    id: clinic.id,
                    name: updatedClinicName!,
                    address: updatedClinicAddress!,
                    phoneNumber: updatedClinicPhoneNumber!,
                    openingTime: updatedClinicOpeningTime!.format(context),
                    closingTime: updatedClinicClosingTime!.format(context),
                    clinicOwnerId: '687fe318-d3a4-4a15-afd7-f5af860d009c',
                  );
                  final response = await http.put(
                    Uri.parse(
                        'http://pets-care.somee.com/api/clinics/${clinic.id}'),
                    headers: {
                      'Authorization': 'Bearer ${user!.token}',
                      'Content-Type': 'application/json'
                    },
                    body: jsonEncode(updatedClinic.toJson()),
                  );

                  if (response.statusCode == 204) {
                    setState(() {
                      _fetchClinics();
                    });
                    Navigator.pop(context);
                  } else {
                    throw Exception('Failed to update clinic information');
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (updatedClinicName != null) {
      final user = await getUser();

      final response = await http.put(
        Uri.parse('http://pets-care.somee.com/api/clinics/${clinic.id}'),
        headers: {
          'Authorization': 'Bearer ${user!.token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'name': updatedClinicName,
          'address': clinic.address,
          'phoneNumber': clinic.phoneNumber,
          'openingTime': clinic.openingTime,
          'closingTime': clinic.closingTime,
        }),
      );

      if (response.statusCode == 204) {
        setState(() {
          _fetchClinics();
        });
      } else {
        throw Exception('Failed to update clinic name');
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
          "Manage Your Clinics",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
              ),
              onPressed: () async {
                await _createClinic();
              },
              child: const Text('Add Clinic'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: _clinics.isEmpty
                  ? const Center(
                      child: Text(
                        'You don\'t have Clinics.',
                      ),
                    )
                  : ListView.builder(
                      itemCount: _clinics.length,
                      itemBuilder: (BuildContext context, int index) {
                        final clinic = _clinics[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.fromLTRB(5, 8, 5, 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(clinic.name),
                            subtitle: Text(clinic.address),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await _updateClinicName(clinic);
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Confirm'),
                                        content: const Text(
                                          'Are you sure you want to delete this clinic?',
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.of(
                                              context,
                                            ).pop(),
                                            child: const Text(
                                              'Cancel',
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              final user = await getUser();

                                              final response =
                                                  await http.delete(
                                                Uri.parse(
                                                    'http://pets-care.somee.com/api/clinics/${clinic.id}'),
                                                headers: {
                                                  'Authorization':
                                                      'Bearer ${user!.token}'
                                                },
                                              );

                                              if (response.statusCode == 204) {
                                                setState(() {
                                                  _clinics.removeAt(index);
                                                });
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Failed to delete the clinic.',
                                                    ),
                                                  ),
                                                );
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
