import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms/controllers/user_controller.dart';
import 'package:moon_design/moon_design.dart';

class JobDetailsScreen extends StatelessWidget {
  final String bookingId;

  JobDetailsScreen({Key? key, required this.bookingId}) : super(key: key);

  Future<Map<String, dynamic>> _getBookingDetails() async {
    final bookingSnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .get();
    final bookingData = bookingSnapshot.data()!;
    final houseSnapshot = await FirebaseFirestore.instance
        .collection('houses')
        .doc((bookingData['house_id'] as DocumentReference).id)
        .get();
    final houseData = houseSnapshot.data()!;
    return {
      'booking': bookingData,
      'house': houseData,
    };
  }

  final user = UserController().currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getBookingDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading job details'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No job details found'));
          }

          final bookingData = snapshot.data!['booking'];
          final houseData = snapshot.data!['house'];

          return SafeArea(
            child: SingleChildScrollView(
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
                    'Job Details',
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
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade200,
                                image: DecorationImage(
                                  image: houseData['house_picture'].isNotEmpty
                                      ? NetworkImage(houseData['house_picture'])
                                      : const AssetImage(
                                              'assets/placeholder.png')
                                          as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
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
                              const Text("House Information",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Icon(Icons.home, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'House: ${houseData['house_name']}',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
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
                                      'Address: ${houseData['house_address']}',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.meeting_room,
                                      color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'Number of Rooms: ${houseData['house_no_of_rooms']}',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text("Job Information",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Icon(Icons.event, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'Date: ${(bookingData['booking_datetime'] as Timestamp).toDate().toString().split(' ')[0]}',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
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
                                      'Time: ${(bookingData['booking_datetime'] as Timestamp).toDate().toString().split(' ')[1].substring(0, 5)}',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.hourglass_bottom,
                                      color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'Duration: ${bookingData['booking_duration']} hours',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
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
                                      'Wage: RM ${bookingData['booking_total_cost']}',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text("Special Requirements",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              Text(
                                bookingData['booking_requirements'],
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  const Icon(Icons.face, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      'Cleaner: ${bookingData['cleaner_id'] == 'N/A' ? 'No cleaner assigned yet' : bookingData['cleaner_id']}',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
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
                  if (bookingData['booking_status'] == 'Pending') ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: MoonFilledButton(
                            backgroundColor: const Color(0xFF9DC543),
                            buttonSize: MoonButtonSize.lg,
                            onTap: () async {
                              await FirebaseFirestore.instance
                                  .collection('bookings')
                                  .doc(bookingId)
                                  .update({
                                'booking_status': 'Assigned',
                                'cleaner_id': user.id
                              });

                              Navigator.of(context).pop();

                              MoonToast.show(
                                context,
                                backgroundColor: Colors.green[50],
                                leading: Icon(
                                  MoonIcons.time_calendar_success_24_regular,
                                  color: Colors.green[700],
                                ),
                                label: Text(
                                  'Job successfully accepted',
                                  style: TextStyle(color: Colors.green[700]),
                                ),
                              );
                            },
                            label: const Text("Accept Job"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
