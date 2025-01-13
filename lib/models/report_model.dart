class ReportModel {
  final double totalAmount;
  final int totalCount;
  final double averageRating;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<ReviewModel>? reviews;

  ReportModel({
    required this.totalAmount,
    required this.totalCount,
    required this.averageRating,
    this.startDate,
    this.endDate,
    this.reviews,
  });
}

class ReviewModel {
  final String review;
  final DateTime timestamp;

  ReviewModel({
    required this.review,
    required this.timestamp,
  });
}