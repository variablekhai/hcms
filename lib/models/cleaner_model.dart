// lib/models/cleaner_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class CleaningJob {
  final String jobId;
  final String houseId;
  final DateTime jobDateTime;
  final double jobTotalCost;
  final String houseName;
  final String houseImage;
  final String houseAddress;
  final String jobStatus;
  final String cleanerId;
  final String bookingRequirements;
  final int bookingDuration;
  final int houseNoOfRooms;

  CleaningJob({
    required this.jobId,
    required this.houseId,
    required this.jobDateTime,
    required this.jobTotalCost,
    required this.houseName,
    required this.houseImage,
    required this.houseAddress,
    required this.jobStatus,
    required this.cleanerId,
    required this.bookingRequirements,
    required this.bookingDuration,
    required this.houseNoOfRooms,
  });

  factory CleaningJob.fromMap(Map<String, dynamic> bookingData, Map<String, dynamic> houseData) {
    return CleaningJob(
      jobId: bookingData['id'],
      houseId: bookingData['house_id'].id,
      jobDateTime: (bookingData['booking_datetime'] as Timestamp).toDate(),
      jobTotalCost: bookingData['booking_total_cost'],
      houseName: houseData['house_name'],
      houseImage: houseData['house_picture'],
      houseAddress: houseData['house_address'],
      jobStatus: bookingData['booking_status'],
      cleanerId: bookingData['cleaner_id'],
      bookingRequirements: bookingData['booking_requirements'],
      bookingDuration: bookingData['booking_duration'],
      houseNoOfRooms: houseData['house_no_of_rooms'],
    );
  }
}

class CleaningActivity {
  final String bookingId;
  final DateTime activityStartTime;
  final String activityDetails;
  final String activityPicture;

  CleaningActivity({
    required this.bookingId,
    required this.activityStartTime,
    required this.activityDetails,
    required this.activityPicture,
  });

  Map<String, dynamic> toMap() {
    return {
      'booking_id': FirebaseFirestore.instance.collection('bookings').doc(bookingId),
      'activity_start_time': activityStartTime,
      'activity_details': activityDetails,
      'activity_picture': activityPicture,
    };
  }
}