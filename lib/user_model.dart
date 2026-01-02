class UserModel {
  final String? id;
  final String name;
  final String phone;
  final String city;
  final String age;

  UserModel({
    this.id,
    required this.name,
    required this.phone,
    required this.city,
    required this.age,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'city': city,
      'age': age,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'] ?? '',
      age: json['age'] ?? '',
    );
  }
}