// lib/controllers/cleaner_controller.dart

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hcms/models/cleaner_model.dart';

class CleanerController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<CleaningJob>> getCleaningJobs(String? cleanerId, String status) {
    return _firestore
        .collection('bookings')
        .snapshots()
        .asyncMap((bookingSnapshot) async {
      List<CleaningJob> jobs = [];
      for (var doc in bookingSnapshot.docs) {
        if (_filterJobByStatus(doc.data(), status, cleanerId!)) {
          final houseDoc = await _firestore
              .collection('houses')
              .doc(doc['house_id'].id)
              .get();
          jobs.add(CleaningJob.fromMap(doc.data(), houseDoc.data()!));
        }
      }
      return jobs;
    });
  }

  bool _filterJobByStatus(Map<String, dynamic> booking, String status, String cleanerId) {
    switch (status) {
      case 'Pending':
        return booking['booking_status'] == 'Pending';
      case 'Ongoing':
        return booking['cleaner_id'] == cleanerId &&
            booking['booking_status'] != 'Completed';
      case 'Completed':
        return booking['cleaner_id'] == cleanerId &&
            booking['booking_status'] == 'Completed';
      default:
        return false;
    }
  }

  Future<CleaningJob> getJobDetails(String bookingId) async {
    final bookingDoc = await _firestore.collection('bookings').doc(bookingId).get();
    final houseDoc = await _firestore
        .collection('houses')
        .doc(bookingDoc['house_id'].id)
        .get();
    return CleaningJob.fromMap(bookingDoc.data()!, houseDoc.data()!);
  }

  Future<void> acceptJob(String bookingId, String cleanerId) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'booking_status': 'Assigned',
      'cleaner_id': cleanerId
    });
  }

  Future<String> uploadImage(Uint8List imageBytes) async {
    final storageRef = _storage
        .ref()
        .child('house_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = storageRef.putData(imageBytes);
    final snapshot = await uploadTask.whenComplete(() => {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl.replaceFirst('download', 'view');
  }

  Future<void> updateCleaningStatus(
    CleaningActivity activity,
    bool isJobCompleted,
    String bookingId,
  ) async {
    await _firestore.collection('cleaningactivity').add(activity.toMap());

    if (isJobCompleted) {
      await _firestore
          .collection('bookings')
          .doc(bookingId)
          .update({'booking_status': 'Waiting for Payment'});
    }
  }
}