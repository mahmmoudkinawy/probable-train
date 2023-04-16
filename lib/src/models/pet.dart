class Pet {
  final String id;
  final String name;
  final String breed;
  final String color;
  final String notes;
  final String imageUrl;
  final int age;

  Pet({
    required this.id,
    required this.name,
    required this.breed,
    required this.color,
    required this.notes,
    required this.imageUrl,
    required this.age,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      breed: json['breed'],
      color: json['color'],
      notes: json['notes'],
      imageUrl: json['imageUrl'],
      age: json['age'],
    );
  }
}
