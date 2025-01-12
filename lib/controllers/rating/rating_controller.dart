import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RatingController {
  RatingController._();

  static final RatingController instance = RatingController._();

  String review = '';

  void addRating(
      BuildContext context, String bookingId, double rating, String cleanerID, String ownerID) {
    Map<String, dynamic> ratingDetails = {
      'booking_id': bookingId,
      'owner_id': ownerID,
      'cleaner_id': cleanerID,
      'rating_score': rating,
      'rating_review': review,
      'rating_date': DateTime.now(),
    };
    FirebaseFirestore.instance
        .collection('ratings')
        .add(ratingDetails)
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rating added!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add rating: $error')),
      );
    });
  }

  void updateReview(String Review) {
    review = Review;
    print('Review controller: $review');
  }
}
