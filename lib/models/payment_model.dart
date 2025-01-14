class Payment {
  final String bookingId;
  final double amount;
  final String paymentMethod;
  final DateTime paymentDate;
  final String paymentStatus;

  Payment({
    required this.bookingId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentDate,
    required this.paymentStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'booking_id': bookingId,
      'payment_amount': amount,
      'payment_method': paymentMethod,
      'payment_date': paymentDate.toIso8601String(),
      'payment_status': paymentStatus,
    };
  }
}
