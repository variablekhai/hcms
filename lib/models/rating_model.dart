class Rating {
  final String bookingId;
  final String ownerId;
  final String cleanerId;
  final double ratingScore;
  final String ratingReview;
  final DateTime ratingDate;

  Rating({
    required this.bookingId,
    required this.ownerId,
    required this.cleanerId,
    required this.ratingScore,
    required this.ratingReview,
    required this.ratingDate,
  });

  // Convert the object to a Map
  Map<String, dynamic> toMap() {
    return {
      'booking_id': bookingId,
      'owner_id': ownerId,
      'cleaner_id': cleanerId,
      'rating_score': ratingScore,
      'rating_review': ratingReview,
      'rating_date': ratingDate.toIso8601String(),
    };
  }
}
