import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumex_users_app/features/profile/models/user_model.dart';

final profileServiceProvider = Provider((ref) {
  return ProfileService(FirebaseFirestore.instance);
});

final userProvider = StreamProvider.autoDispose.family<UserModel?, String>((
  ref,
  uid,
) {
  return ref.watch(profileServiceProvider).getUserStream(uid);
});

class ProfileService {
  final FirebaseFirestore _firestore;

  ProfileService(this._firestore);

  CollectionReference get _usersCollection => _firestore.collection('users');

  // Get a stream of user data
  Stream<UserModel?> getUserStream(String uid) {
    return _usersCollection.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromFirestore(snapshot);
      }
      return null;
    });
  }

  // Get user data once
  Future<UserModel?> getUser(String uid) async {
    final snapshot = await _usersCollection.doc(uid).get();
    if (snapshot.exists) {
      return UserModel.fromFirestore(snapshot);
    }
    return null;
  }

  // Update user data
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    // Ensure `edited_time` is updated with every change
    final dataToUpdate = {...data, 'edited_time': FieldValue.serverTimestamp()};
    await _usersCollection.doc(uid).update(dataToUpdate);
  }

  // Set user data (used for creating new user documents)
  Future<void> setUserData(String uid, Map<String, dynamic> data) async {
    await _usersCollection.doc(uid).set(data, SetOptions(merge: true));
  }
}
