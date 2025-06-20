import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String customId;
  final String accessLevel;
  final Timestamp createdTime;
  Timestamp editedTime;
  String? displayName;
  String? email;
  String? lastName;
  String? phoneNumber;
  String? photoUrl;
  String? doctorIdCard;
  String? speciality;

  UserModel({
    required this.uid,
    required this.customId,
    this.accessLevel = 'User',
    required this.createdTime,
    required this.editedTime,
    this.displayName,
    this.email,
    this.lastName,
    this.phoneNumber,
    this.photoUrl,
    this.doctorIdCard,
    this.speciality,
  });

  // Factory constructor to create a UserModel from a Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'] ?? '',
      customId: data['custom_id'] ?? '',
      accessLevel: data['access_level'] ?? 'User',
      createdTime: data['created_time'] ?? Timestamp.now(),
      editedTime: data['edited_time'] ?? Timestamp.now(),
      displayName: data['display_name'],
      email: data['email'],
      lastName: data['last_name'],
      phoneNumber: data['phone_number'],
      photoUrl: data['photo_url'],
      doctorIdCard: data['doctor_id_card']?.toString(),
      speciality: data['speciallity'],
    );
  }

  // Method to convert UserModel to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'custom_id': customId,
      'access_level': accessLevel,
      'created_time': createdTime,
      'edited_time': editedTime,
      if (displayName != null) 'display_name': displayName,
      if (email != null) 'email': email,
      if (lastName != null) 'last_name': lastName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (doctorIdCard != null) 'doctor_id_card': doctorIdCard,
      if (speciality != null) 'speciallity': speciality,
    };
  }
}
