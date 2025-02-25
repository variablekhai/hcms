import 'package:flutter/material.dart';
import 'package:hcms/controllers/booking/booking_controller.dart';
import 'package:hcms/controllers/user_controller.dart';
import 'package:hcms/models/booking_model.dart';
import 'package:hcms/screens/booking/add_booking.dart';
import 'package:hcms/screens/booking/booking_details.dart';
import 'package:hcms/screens/booking/widgets/filters_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'widgets/status_chip.dart';

Widget _buildHeader() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding:
            const EdgeInsets.only(left: 25, right: 25, top: 40, bottom: 25),
        child: Row(
          children: [
            const Text(
              'Hi, Khairul ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 5),
            Image.asset(
              'assets/wave.png',
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Text(
          'My Bookings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}

class BookingList extends StatefulWidget {
  BookingList({super.key});

  @override
  _BookingListState createState() => _BookingListState();

  final user = UserController().currentUser!;
  final _bookingController = BookingController();
}

class _BookingListState extends State<BookingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          // Filters Section
          Container(
            margin:
                const EdgeInsets.only(top: 20, bottom: 7, left: 25, right: 25),
            child: const Dropdown(),
          ),
          // Booking List Section
          Expanded(
            child: StreamBuilder<List<BookingModel>>(
              stream: widget._bookingController.getBookingsByOwnerId(widget.user.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('You have not made any bookings.'));
                }
                final bookings = snapshot.data!;
                return ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return BookingCard(
                      bookingId: booking.id,
                      houseId: booking.houseId,
                      cleanerId: booking.cleanerId,
                      bookingDateTime: booking.bookingDateTime.toString(),
                      bookingStatus: booking.bookingStatus,
                      bookingTotalCost: booking.bookingTotalCost,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF9DC543),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookingScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class BookingCard extends StatefulWidget {
  final String bookingId;
  final String houseId;
  final String cleanerId;
  final String bookingDateTime;
  final String bookingStatus;
  final double bookingTotalCost;

  const BookingCard({
    super.key,
    required this.bookingId,
    required this.houseId,
    required this.cleanerId,
    required this.bookingDateTime,
    required this.bookingStatus,
    required this.bookingTotalCost,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BookingCardState createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  String houseName = '';
  String houseImage = '';
  String houseAddress = '';

  Future<DocumentSnapshot> getHouseData(String houseId) async {
    return await FirebaseFirestore.instance
        .collection('houses')
        .doc(houseId)
        .get();
  }

  @override
  void initState() {
    super.initState();
    getHouseData(widget.houseId).then((houseData) {
      setState(() {
        houseName = houseData['house_name'];
        houseImage = houseData['house_picture'];
        houseAddress = houseData['house_address'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookingDetails(
                        bookingId: widget.bookingId,
                      )),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Placeholder
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: houseImage.isNotEmpty
                          ? NetworkImage(houseImage)
                          : const AssetImage('assets/house-placeholder.png')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        houseName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.event, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.bookingDateTime.split(' ')[0].split('-')[2]}/${widget.bookingDateTime.split(' ')[0].split('-')[1]}/${widget.bookingDateTime.split(' ')[0].split('-')[0]}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.schedule,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${int.parse(widget.bookingDateTime.split(' ')[1].substring(0, 2)) % 12 == 0 ? 12 : int.parse(widget.bookingDateTime.split(' ')[1].substring(0, 2)) % 12}:${widget.bookingDateTime.split(' ')[1].substring(3, 5)} ${int.parse(widget.bookingDateTime.split(' ')[1].substring(0, 2)) >= 12 ? 'PM' : 'AM'}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.payments,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'RM ${widget.bookingTotalCost.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.face, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            widget.cleanerId == 'N/A'
                                ? 'No cleaner assigned yet'
                                : 'Cleaner assigned',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 35,
          child: StatusChip(status: widget.bookingStatus),
        ),
      ],
    );
  }
}
