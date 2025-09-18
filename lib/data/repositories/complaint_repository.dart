

import '../services/firestore_service.dart';

class ComplaintRepository {
  final FirestoreService fs;

  ComplaintRepository(this.fs);

  Future<void> addComplaint(Map<String, dynamic> complaint) async {
    await fs.complaintsRef.add(complaint);
  }

  Stream getComplaints() {
    return fs.complaintsRef.snapshots();
  }
}
