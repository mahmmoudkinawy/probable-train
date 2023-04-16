class Clinic {
  String id;
  String name;
  String address;
  String phoneNumber;
  String openingTime;
  String closingTime;
  String clinicOwnerId;

  Clinic(
      {required this.id,
      required this.name,
      required this.address,
      required this.phoneNumber,
      required this.openingTime,
      required this.closingTime,
      required this.clinicOwnerId});

  factory Clinic.fromJson(Map<String, dynamic> json) {
    try {
      return Clinic(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        address: json['address'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
        openingTime: json['openingTime'] ?? '',
        closingTime: json['closingTime'] ?? '',
        clinicOwnerId: json['clinicOwnerId'] ?? '',
      );
    } catch (e) {
      print('Error parsing clinic JSON: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'clinicOwnerId': clinicOwnerId,
    };
  }

  void setName(String newName) {
    name = newName;
  }
}
