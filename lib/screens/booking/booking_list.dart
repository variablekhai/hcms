import 'package:flutter/material.dart';
import 'package:hcms/screens/booking/add_booking.dart';
import 'package:hcms/screens/booking/booking_details.dart';
import 'package:hcms/screens/booking/widgets/filters_dropdown.dart';

Widget _buildHeader() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 25, right: 25, top: 40, bottom: 25),
        child: Row(
            children: [
            Text(
              'Hi, Khairul ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5),
            Image.asset(
              'wave.png',
              height: 24,
              width: 24,
            ),
            ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Text(
          'My Bookings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}

class BookingList extends StatelessWidget {
  const BookingList({Key? key}) : super(key: key);

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
            child: ListView.builder(
              itemCount: 5, // Replace with your booking list count
              itemBuilder: (context, index) {
                return const BookingCard();
              },
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
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

class BookingCard extends StatelessWidget {
  const BookingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BookingDetails()),
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
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: AssetImage('barefoot-villa.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Barefoot Villa',
                        style: TextStyle(
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
                            '12/12/2024',
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
                            '1:00 PM - 3:00 PM',
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
                            'John Doe',
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
        const Positioned(
          top: 20,
          right: 35,
          child: StatusChip(status: 'Completed'), // Replace with dynamic status
        ),
      ],
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color chipColor;
    switch (status) {
      case 'Assigned':
        chipColor = Colors.blue;
        break;
      case 'Pending':
        chipColor = Colors.orange;
        break;
      case 'Completed':
        chipColor = Colors.green;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(
      status,
      style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: chipColor,
      shape: RoundedRectangleBorder(
      side: BorderSide(color: chipColor),
      borderRadius: BorderRadius.circular(15),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
