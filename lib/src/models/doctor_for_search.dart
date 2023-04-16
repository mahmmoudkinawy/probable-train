class DoctorForSearch {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String specialty;
  final String gender;
  final int experience;
  final String imageUrl;

  DoctorForSearch({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.specialty,
    required this.gender,
    required this.experience,
    required this.imageUrl,
  });

  factory DoctorForSearch.fromJson(Map<String, dynamic> json) {
    return DoctorForSearch(
      id: json['id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      specialty: json['specialty'],
      gender: json['gender'],
      experience: json['experience'],
      imageUrl: json['imageUrl'],
    );
  }
}
