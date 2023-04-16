class Appointment {
  final DateTime appointmentDate;
  final String patientName;
  final String patientEmail;
  final String phoneNumber;
  final String? notes;

  Appointment({
    required this.appointmentDate,
    required this.patientName,
    required this.patientEmail,
    required this.phoneNumber,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'appointmentDate': appointmentDate.toIso8601String(),
      'patientName': patientName,
      'patientEmail': patientEmail,
      'phoneNumber': phoneNumber,
      'notes': notes,
    };
  }
}
