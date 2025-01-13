import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms/models/report_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

class ReportController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ReportModel> fetchCleanerReport(String cleanerId, {DateTime? startDate, DateTime? endDate}) async {
    try {
      // Fetch earnings
      QuerySnapshot earningsSnapshot = await _firestore
          .collection('bookings')
          .where('cleaner_id', isEqualTo: cleanerId)
          .where('booking_status', isEqualTo: 'Completed')
          .get();

      double totalEarnings = 0.0;
      int totalJobs = 0;

      for (var doc in earningsSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        DateTime bookingDate = (data['booking_datetime'] as Timestamp).toDate();
        
        if ((startDate == null || bookingDate.isAfter(startDate)) &&
            (endDate == null || bookingDate.isBefore(endDate))) {
          totalEarnings += data['booking_total_cost'];
          totalJobs++;
        }
      }

      // Fetch ratings
      QuerySnapshot ratingsSnapshot = await _firestore
          .collection('ratings')
          .where('cleaner_id', isEqualTo: cleanerId)
          .get();

      double totalRating = 0.0;
      int ratingCount = ratingsSnapshot.docs.length;

      for (var doc in ratingsSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        totalRating += data['rating_score'];
      }

      double averageRating = ratingCount > 0 ? totalRating / ratingCount : 0.0;

      // Fetch reviews
      List<ReviewModel> reviews = await fetchRecentReviews(cleanerId);

      return ReportModel(
        totalAmount: totalEarnings,
        totalCount: totalJobs,
        averageRating: averageRating,
        startDate: startDate,
        endDate: endDate,
        reviews: reviews,
      );
    } catch (e) {
      throw Exception('Failed to fetch cleaner report: $e');
    }
  }

  Future<ReportModel> fetchOwnerReport(String ownerId, {DateTime? startDate, DateTime? endDate}) async {
    try {
      QuerySnapshot bookingsSnapshot = await _firestore
          .collection('bookings')
          .where('owner_id', isEqualTo: ownerId)
          .where('booking_status', isEqualTo: 'Completed')
          .get();

      double totalSpent = 0.0;
      int totalBookings = 0;

      for (var doc in bookingsSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        DateTime bookingDate = (data['booking_datetime'] as Timestamp).toDate();
        
        if ((startDate == null || bookingDate.isAfter(startDate)) &&
            (endDate == null || bookingDate.isBefore(endDate))) {
          totalSpent += data['booking_total_cost'];
          totalBookings++;
        }
      }

      // Fetch ratings given
      QuerySnapshot ratingsSnapshot = await _firestore
          .collection('ratings')
          .where('owner_id', isEqualTo: ownerId)
          .get();

      double totalRating = 0.0;
      int ratingCount = ratingsSnapshot.docs.length;

      for (var doc in ratingsSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        totalRating += data['rating_score'];
      }

      double averageRating = ratingCount > 0 ? totalRating / ratingCount : 0.0;

      return ReportModel(
        totalAmount: totalSpent,
        totalCount: totalBookings,
        averageRating: averageRating,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      throw Exception('Failed to fetch owner report: $e');
    }
  }

  Future<List<ReviewModel>> fetchRecentReviews(String cleanerId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('ratings')
          .where('cleaner_id', isEqualTo: cleanerId)
          .orderBy('rating_date', descending: true)
          .limit(3)
          .get();

      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return ReviewModel(
          review: data['rating_review'],
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch reviews: $e');
    }
  }

  Future<void> exportReport(ReportModel report, bool isCleaner) async {
    try {
      final pdf = pw.Document();
      
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text(isCleaner ? 'Cleaner Report' : 'House Owner Report'),
                pw.Text('Total ${isCleaner ? 'Earnings' : 'Spent'}: RM${report.totalAmount.toStringAsFixed(2)}'),
                pw.Text('Total ${isCleaner ? 'Jobs' : 'Bookings'}: ${report.totalCount}'),
                pw.Text('Average Rating: ${report.averageRating.toStringAsFixed(1)}/5'),
              ],
            );
          },
        ),
      );

      final directory = await getExternalStorageDirectory();
      final downloadsPath = "${directory!.path}/Downloads";
      final file = File("$downloadsPath/${isCleaner ? 'cleaner' : 'owner'}_report.pdf");
      
      await Directory(downloadsPath).create(recursive: true);
      await file.writeAsBytes(await pdf.save());
    } catch (e) {
      throw Exception('Failed to export report: $e');
    }
  }
}