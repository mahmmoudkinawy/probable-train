class Doctor {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String specialty;
  final String? imageUrl;
  final String gender;
  final int experience;

  Doctor({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.specialty,
    this.imageUrl,
    required this.gender,
    required this.experience,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      specialty: json['specialty'],
      imageUrl: json['imageUrl'],
      gender: json['gender'],
      experience: json['experience'],
    );
  }
}
