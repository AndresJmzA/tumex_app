import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProcedureService {
  final FirebaseFirestore _firestore;

  ProcedureService(this._firestore);

  // Fetch all surgeries
  Future<List<QueryDocumentSnapshot>> getSurgeries() async {
    final snapshot = await _firestore.collection('Surgery').get();

    print('🏥 Found ${snapshot.docs.length} surgeries');

    // Debug: Print all surgeries to see their structure
    for (final doc in snapshot.docs) {
      print('📄 Surgery: ${doc.data()}');
    }

    return snapshot.docs;
  }

  // Fetch procedures for a specific surgery
  Future<List<QueryDocumentSnapshot>> getProceduresForSurgery(
      DocumentReference surgeryRef) async {
    print('🔍 Searching for procedures with surgeryRef: ${surgeryRef.path}');

    final snapshot = await _firestore
        .collection('Procedure')
        .where('surgeryRef', isEqualTo: surgeryRef.id)
        .get();

    print('📊 Found ${snapshot.docs.length} procedures');

    // Debug: Print all procedures to see their structure
    for (final doc in snapshot.docs) {
      print('📄 Procedure: ${doc.data()}');
    }

    return snapshot.docs;
  }

  // Fetch template items for a specific procedure
  Future<List<QueryDocumentSnapshot>> getTemplateItemsForProcedure(
      DocumentReference procedureRef) async {
    final snapshot = await procedureRef.collection('templateItems').get();
    return snapshot.docs;
  }
}

// Provider for the service
final procedureServiceProvider = Provider((ref) {
  return ProcedureService(FirebaseFirestore.instance);
});
