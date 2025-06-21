import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  final String id;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final bool isDefault;

  Address({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    this.isDefault = false,
  });

  factory Address.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return Address(
      id: snap.id,
      street: data['street'] ?? '',
      city: data['city'] ?? '',
      state: data['State'] ?? '',
      zipCode: (data['postal_code'] ?? 0).toString(),
      isDefault: data['isDefault'] ?? false,
    );
  }

  @override
  String toString() {
    return '$street, $city, $state, $zipCode';
  }
}
