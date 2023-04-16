import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'package:petscareclient/src/extensions/string_casing_extension.dart';

import '../models/appointment.dart';
import '../models/clinic.dart';
import '../models/doctor.dart';
import '../models/user.dart';
import 'home_screen.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  String selectedDoctorId = '';
  String selectedClinicId = '';
  String patientName = '';
  String patientEmail = '';
  String phoneNumber = '';
  String notes = '';

  List<Doctor> doctors = [];
  List<Clinic> clinics = [];

  Future<void> fetchDoctors() async {
    final user = await getUser();

    final response = await http.get(
        Uri.parse('http://pets-care.somee.com/api/doctors'),
        headers: {'Authorization': 'Bearer ${user!.token}'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final fetchedDoctors = data.map((e) => Doctor.fromJson(e)).toList();

      setState(() {
        doctors = fetchedDoctors;
      });
    } else {
      print('Failed to fetch doctors. Error code: ${response.statusCode}');
    }
  }

  Future<void> fetchClinics() async {
    final user = await getUser();

    final response = await http.get(
        Uri.parse('http://pets-care.somee.com/api/clinics'),
        headers: {'Authorization': 'Bearer ${user!.token}'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final fetchedClinics = data.map((e) => Clinic.fromJson(e)).toList();

      setState(() {
        clinics = fetchedClinics;
      });
    } else {
      print('Failed to fetch clinics. Error code: ${response.statusCode}');
    }
  }

  Future<void> submitAppointment() async {
    final user = await getUser();

    _formKey.currentState!.save();

    final formData = _formKey.currentState!.value;

    final appointment = Appointment(
      appointmentDate: formData['appointmentDate'],
      patientName: formData['patientName'],
      patientEmail: formData['patientEmail'],
      phoneNumber: formData['phoneNumber'],
      notes: formData['notes'],
    );

    final response = await http.post(
      Uri.parse(
          'http://pets-care.somee.com/api/doctors/$selectedDoctorId/clinics/$selectedClinicId/appointments'),
      headers: {
        'Authorization': 'Bearer ${user!.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'appointmentDate': appointment.appointmentDate.toIso8601String(),
        'patientName': appointment.patientName,
        'patientEmail': appointment.patientEmail,
        'phoneNumber': appointment.phoneNumber,
        'notes': appointment.notes,
      }),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Appointment booked successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const HomeScreen(),
        ),
      );
    } else if (response.statusCode == 400) {
      Fluttertoast.showToast(
          msg: "Please ask for another appointment.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(response.body);
      print('Failed to create appointment. Error code: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDoctors();
    fetchClinics();
  }

  @override
  Widget build(BuildContext context) {
    if (doctors.isEmpty || clinics.isEmpty) {
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

    final String initialDoctorId = doctors.first.id;
    final List<Clinic> clinicsForInitialDoctor =
        clinics.where((clinic) => clinic.id == initialDoctorId).toList();

    var initialClinicId = clinicsForInitialDoctor.isNotEmpty
        ? clinicsForInitialDoctor.first.id
        : null;

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
          'Appointments',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Material(
            color: Colors.grey.shade200,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderDropdown<String>(
                        name: 'doctor',
                        initialValue: selectedDoctorId.isNotEmpty
                            ? selectedDoctorId
                            : initialDoctorId,
                        decoration: const InputDecoration(
                          labelText: 'Select a Doctor',
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedDoctorId = value!;
                            final clinicsForSelectedDoctor = clinics
                                .where((clinic) => clinic.clinicOwnerId == value)
                                .toList();
                            if (clinicsForSelectedDoctor.isNotEmpty) {
                              selectedClinicId = clinicsForSelectedDoctor.first.id;
                            }
                          });
                        },
                        items: doctors
                            .map(
                              (doctor) => DropdownMenuItem<String>(
                                value: doctor.id,
                                child: Text(
                                  doctor.fullName.toTitleCase(),
                                ),
                              ),
                            )
                            .toList(),
                        validator: FormBuilderValidators.required(),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderDropdown<String>(
                        name: 'clinic',
                        initialValue: selectedClinicId.isNotEmpty
                            ? selectedClinicId
                            : initialClinicId,
                        decoration: const InputDecoration(
                          labelText: 'Select a Clinic',
                        ),
                        onChanged: (value) {
                          setState(
                            () {
                              selectedClinicId = value!;
                            },
                          );
                        },
                        items: clinics
                            .where((clinic) => clinic.clinicOwnerId == selectedDoctorId)
                            .map(
                              (clinic) => DropdownMenuItem<String>(
                                value: clinic.id,
                                child: Text(
                                  clinic.name.toTitleCase(),
                                ),
                              ),
                            )
                            .toList(),
                        validator: FormBuilderValidators.required(),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderDateTimePicker(
                        name: 'appointmentDate',
                        initialValue: DateTime.now(),
                        inputType: InputType.both,
                        decoration: const InputDecoration(
                          labelText: 'Date',
                        ),
                        validator: FormBuilderValidators.required(),
                        selectableDayPredicate: (DateTime date) {
                          // Disable Fridays and Saturdays
                          return date.weekday != DateTime.friday &&
                              date.weekday != DateTime.saturday;
                        },
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(
                        name: 'patientName',
                        decoration: const InputDecoration(
                          labelText: 'Patient Name',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(3),
                        ]),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(
                        name: 'patientEmail',
                        decoration: const InputDecoration(
                          labelText: 'Patient Email',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(),
                        ]),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(
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
                    ),
                  ),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(
                        name: 'notes',
                        decoration: const InputDecoration(
                          labelText: 'Notes',
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 55,
                    width: 300,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0),
                                side: const BorderSide(color: Colors.black)),
                          ),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(15))),
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        submitAppointment();
                      },
                      child: const Text(
                        'Submit',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
