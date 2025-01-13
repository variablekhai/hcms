// lib/models/booking_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final DateTime bookingDateTime;
  final String bookingStatus;
  final double bookingTotalCost;
  final int bookingDuration;
  final String bookingRequirements;
  final String cleanerId;
  final String houseId;
  final String? ownerId;

  BookingModel({
    required this.id,
    required this.bookingDateTime,
    required this.bookingStatus,
    required this.bookingTotalCost,
    required this.bookingDuration,
    required this.bookingRequirements,
    required this.cleanerId,
    required this.houseId,
    required this.ownerId,
  });

  factory BookingModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return BookingModel(
      id: snapshot.id,
      bookingDateTime: (data['booking_datetime'] as Timestamp).toDate(),
      bookingStatus: data['booking_status'],
      bookingTotalCost: (data['booking_total_cost'] as num).toDouble(),
      bookingDuration: data['booking_duration'],
      bookingRequirements: data['booking_requirements'],
      cleanerId: data['cleaner_id'],
      houseId: (data['house_id'] as DocumentReference).id,
      ownerId: data['owner_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'booking_datetime': Timestamp.fromDate(bookingDateTime),
      'booking_status': bookingStatus,
      'booking_total_cost': bookingTotalCost,
      'booking_duration': bookingDuration,
      'booking_requirements': bookingRequirements,
      'cleaner_id': cleanerId,
      'house_id': FirebaseFirestore.instance.collection('houses').doc(houseId),
      'owner_id': ownerId,
    };
  }
}