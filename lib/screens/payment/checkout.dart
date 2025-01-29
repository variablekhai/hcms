import 'package:flutter/material.dart';
import 'package:hcms/controllers/rating/rating_controller.dart';
import 'package:hcms/models/payment_model.dart';
import 'package:hcms/widgets/bottomNavigationMenu.dart';
import 'package:hcms/widgets/cleaner_rating_bar.dart';
import 'package:moon_design/moon_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms/controllers/user_controller.dart';
import 'package:hcms/screens/booking/widgets/status_chip.dart';
import 'package:hcms/controllers/payment/toyyibpay_service.dart'; // Import ToyyibPay service
import 'package:hcms/screens/payment/payment.dart'; // Payment WebView page

class Checkout extends StatelessWidget {
  final String bookingId;
  double rating;

  Checkout({super.key, required this.bookingId, this.rating = 5});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .doc(bookingId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Booking not found'));
          }

          var bookingData = snapshot.data!.data() as Map<String, dynamic>;
          bookingData['booking_datetime'] =
              (bookingData['booking_datetime'] as Timestamp)
                  .toDate()
                  .toString();
          var houseRef = bookingData['house_id'] as DocumentReference;

          return FutureBuilder<DocumentSnapshot>(
            future: houseRef.get(),
            builder: (context, houseSnapshot) {
              if (houseSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!houseSnapshot.hasData || !houseSnapshot.data!.exists) {
                return const Center(child: Text('House not found'));
              }

              var houseData =
                  houseSnapshot.data!.data() as Map<String, dynamic>;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Other UI Components...
                      if (bookingData['booking_status'] ==
                          "Waiting for Payment") ...[
                        const SizedBox(height: 16),
                        Text(
                          'Total: RM${bookingData['booking_total_cost'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: MoonFilledButton(
                                buttonSize: MoonButtonSize.lg,
                                backgroundColor: const Color(0xFF9DC543),
                                onTap: () async {
                                  try {
                                    final toyyibPayService = ToyyibPayService();

                                    // Generate the bill with required parameters
                                    String? billCode =
                                        await toyyibPayService.createBill(
                                      billTitle: 'Booking Payment',
                                      billDescription:
                                          'Payment for booking ID: $bookingId',
                                      billAmount:
                                          (bookingData['booking_total_cost'] *
                                                  100)
                                              .toStringAsFixed(0),
                                      userEmail: "danialnabil0208@gmail.com",
                                      userPhone: "01123138061",
                                      categoryCode:
                                          'r53xplxf', // Replace with your category code
                                    );

                                    if (billCode != null) {
                                      // Navigate to the payment page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PaymentPage(billCode: billCode),
                                        ),
                                      );
                                    } else {
                                      throw Exception('Failed to create bill');
                                    }
                                  } catch (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Payment failed: $error'),
                                      ),
                                    );
                                  }
                                },
                                label: const Text("Make Payment"),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
