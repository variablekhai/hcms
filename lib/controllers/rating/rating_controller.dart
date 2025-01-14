import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hcms/models/rating_model.dart';

class RatingController {
  RatingController._();

  static final RatingController instance = RatingController._();

  String review = '';

  Future<void> addRating(BuildContext context, String bookingId, double rating,
      String cleanerID, String ownerID) async {
    Rating ratingModel = Rating(
      bookingId: bookingId,
      ownerId: ownerID,
      cleanerId: cleanerID,
      ratingScore: rating,
      ratingReview: review,
      ratingDate: DateTime.now(),
    );
    FirebaseFirestore.instance
        .collection('ratings')
        .add(ratingModel.toMap())
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
