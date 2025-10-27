import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;

class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String phone;
  final String city;
  final String ward;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.city,
    required this.ward,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      phone: data['phone'] ?? '',
      city: data['city'] ?? '',
      ward: data['ward'] ?? '',
    );
  }
}
