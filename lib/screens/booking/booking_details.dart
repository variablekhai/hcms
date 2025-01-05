import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hcms/screens/booking/edit_booking.dart';
import 'package:hcms/screens/booking/widgets/status_chip.dart';
import 'package:moon_design/moon_design.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const BookingDetails(bookingId: '123'),
    );
  }
}

class BookingDetails extends StatelessWidget {
  final String bookingId;

  const BookingDetails({super.key, required this.bookingId});

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
          bookingData['booking_datetime'] = (bookingData['booking_datetime'] as Timestamp).toDate().toString();
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

              var houseData = houseSnapshot.data!.data() as Map<String, dynamic>;

              return Padding(
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
                      'Booking Details',
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
                                        : const AssetImage('assets/placeholder.png')
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
                                  child: StatusChip(status: bookingData['booking_status']),
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
                                    const Icon(Icons.event, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'Date: ${bookingData['booking_datetime'].split(' ')[0].split('-')[2]}/${bookingData['booking_datetime'].split(' ')[0].split('-')[1]}/${bookingData['booking_datetime'].split(' ')[0].split('-')[0]}',
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
                                    const Icon(Icons.schedule, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'Time: ${bookingData['booking_datetime'].split(' ')[1].substring(0, 5)} ${int.parse(bookingData['booking_datetime'].split(' ')[1].substring(0, 2)) >= 12 ? 'PM' : 'AM'}',
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
                                    const Icon(Icons.location_on, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'Location: ${houseData['house_address']}',
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
                                    const Icon(Icons.payments, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'Wage: ${bookingData['booking_total_cost'].toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.black),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
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
                            child: MoonOutlinedButton(
                              buttonSize: MoonButtonSize.lg,
                              onTap: bookingData['booking_status'] == 'Assigned'
                                  ? null
                                  : () {
                                      showMoonModal<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return MoonModal(
                                            child: SizedBox(
                                              height: 150,
                                              width: MediaQuery.of(context).size.width -
                                                  64,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                      "Are you sure you want to cancel the booking?"),
                                                  const SizedBox(height: 16),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: MoonFilledButton(
                                                            label: const Text("Yes"),
                                                            onTap: () async {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'bookings')
                                                                  .doc(bookingId)
                                                                  .update({
                                                                'booking_status':
                                                                    'Cancelled'
                                                              });

                                                              MoonToast.show(
                                                                context,
                                                                backgroundColor:
                                                                    Colors.green[50],
                                                                leading: Icon(
                                                                  MoonIcons
                                                                      .time_calendar_success_24_regular,
                                                                  color:
                                                                      Colors.green[700],
                                                                ),
                                                                label: Text(
                                                                  'Booking successfully cancelled',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green[700]),
                                                                ),
                                                              );
                                                              Navigator.of(context)
                                                                  .pop();
                                                              Navigator.of(context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Expanded(
                                                          child: MoonOutlinedButton(
                                                            label: const Text("No"),
                                                            onTap: () {
                                                              Navigator.of(context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                              label: const Text("Cancel Booking"),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: MoonFilledButton(
                              buttonSize: MoonButtonSize.lg,
                              onTap: bookingData['booking_status'] == 'Assigned'
                                  ? null
                                  : () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => EditBookingScreen(bookingId: bookingId, houseId: bookingData['house_id'].id),
                                        ),
                                      );
                                    },
                              label: const Text("Edit Booking"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
