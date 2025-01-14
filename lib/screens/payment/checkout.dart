import 'package:flutter/material.dart';
import 'package:hcms/controllers/payment/payment_controller.dart';
import 'package:hcms/controllers/rating/rating_controller.dart';
import 'package:hcms/models/payment_model.dart';
import 'package:hcms/widgets/bottomNavigationMenu.dart';
import 'package:hcms/widgets/cleaner_rating_bar.dart';
import 'package:moon_design/moon_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms/controllers/user_controller.dart';
import 'package:hcms/screens/booking/widgets/status_chip.dart';

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
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(MoonIcons.arrows_left_24_regular),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          const Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey.shade200,
                                    image: DecorationImage(
                                      image:
                                          houseData['house_picture'].isNotEmpty
                                              ? NetworkImage(
                                                  houseData['house_picture'])
                                              : const AssetImage(
                                                      'assets/placeholder.png')
                                                  as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 12),
                                    child: StatusChip(
                                        status: bookingData['booking_status']),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.home,
                                          color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'House: ${houseData['house_name']}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.event,
                                          color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'Date: ${bookingData['booking_datetime'].split(' ')[0].split('-')[2]}/${bookingData['booking_datetime'].split(' ')[0].split('-')[1]}/${bookingData['booking_datetime'].split(' ')[0].split('-')[0]}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.schedule,
                                          color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'Time: ${int.parse(bookingData['booking_datetime'].split(' ')[1].substring(0, 2)) % 12 == 0 ? 12 : int.parse(bookingData['booking_datetime'].split(' ')[1].substring(0, 2)) % 12}:${bookingData['booking_datetime'].split(' ')[1].substring(3, 5)} ${int.parse(bookingData['booking_datetime'].split(' ')[1].substring(0, 2)) >= 12 ? 'PM' : 'AM'}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'Location: ${houseData['house_address']}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.payments,
                                          color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'Wage: RM ${bookingData['booking_total_cost'].toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    children: [
                                      const Icon(Icons.face,
                                          color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'Cleaner: ${bookingData['cleaner_id'] == 'N/A' ? 'No cleaner assigned yet' : UserController().getNameById(bookingData['cleaner_id'])}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
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
                                onTap: () {
                                  final payment = Payment(
                                    bookingId: bookingId,
                                    amount: bookingData['booking_total_cost'],
                                    paymentMethod: 'Credit Card',
                                    paymentDate: DateTime.now(),
                                    paymentStatus: 'Paid',
                                  );
                                  PaymentController.instance
                                      .makePayment(context, payment)
                                      .then((_) {
                                    Navigator.of(context).pop();
                                  }).catchError((error) {
                                    // Handle payment failure if needed
                                  });
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
