import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hcms/controllers/booking/booking_controller.dart';
import 'package:hcms/controllers/rating/rating_controller.dart';
import 'package:hcms/controllers/user_controller.dart';
import 'package:hcms/screens/booking/edit_booking.dart';
import 'package:hcms/screens/booking/widgets/status_chip.dart';
import 'package:hcms/screens/payment/checkout.dart';
import 'package:hcms/widgets/bottomNavigationMenu.dart';
import 'package:hcms/widgets/cleaner_rating_bar.dart';
import 'package:moon_design/moon_design.dart';

class BookingDetails extends StatefulWidget {
  final String bookingId;

  const BookingDetails({
    super.key,
    required this.bookingId,
  });

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  final BookingController _bookingController = BookingController();
  double rating = 5;
  bool? isRated;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .doc(widget.bookingId)
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

          return FutureBuilder<List<dynamic>>(
            future: Future.wait([
              houseRef.get(),
              FirebaseFirestore.instance
                  .collection('ratings')
                  .where('booking_id', isEqualTo: widget.bookingId)
                  .get(),
            ]),
            builder: (context, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshots.hasData || !snapshots.data![0].exists) {
                return const Center(child: Text('House not found'));
              }

              var houseData = snapshots.data![0].data() as Map<String, dynamic>;
              var isRated =
                  (snapshots.data![1] as QuerySnapshot).docs.isNotEmpty;

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
                      if (bookingData['booking_status'] == 'Pending') ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: MoonOutlinedButton(
                                buttonSize: MoonButtonSize.lg,
                                onTap: () {
                                  showMoonModal<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return MoonModal(
                                        child: SizedBox(
                                          height: 150,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              64,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                  "Are you sure you want to cancel the booking?"),
                                              const SizedBox(height: 16),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: MoonFilledButton(
                                                        label:
                                                            const Text("Yes"),
                                                        onTap: () async {
                                                          await _bookingController
                                                              .cancelBooking(
                                                                  widget
                                                                      .bookingId);

                                                          MoonToast.show(
                                                            context,
                                                            backgroundColor:
                                                                Colors
                                                                    .green[50],
                                                            leading: Icon(
                                                              MoonIcons
                                                                  .time_calendar_success_24_regular,
                                                              color: Colors
                                                                  .green[700],
                                                            ),
                                                            label: Text(
                                                              'Booking successfully cancelled',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .green[
                                                                      700]),
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
                                backgroundColor: const Color(0xFF9DC543),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EditBookingScreen(
                                          bookingId: widget.bookingId,
                                          houseId: bookingData['house_id'].id),
                                    ),
                                  );
                                },
                                label: const Text("Edit Booking"),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Checkout(
                                            bookingId: widget.bookingId)),
                                  );
                                },
                                label: const Text("Checkout"),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                      if (bookingData['booking_status'] == "Assigned" ||
                          bookingData['booking_status'] ==
                              "Waiting for Payment") ...[
                        const Text(
                          'Booking Updates',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('cleaningactivity')
                              .where('booking_id',
                                  isEqualTo: FirebaseFirestore.instance
                                      .collection('bookings')
                                      .doc(widget.bookingId))
                              .snapshots(),
                          builder: (context, activitySnapshot) {
                            if (activitySnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (!activitySnapshot.hasData ||
                                activitySnapshot.data!.docs.isEmpty) {
                              return const Center(
                                  child: Text('No updates available'));
                            }

                            var activities = activitySnapshot.data!.docs;

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: activities.length,
                              itemBuilder: (context, index) {
                                var activityData = activities[index].data()
                                    as Map<String, dynamic>;
                                var activityTime =
                                    (activityData['activity_start_time']
                                            as Timestamp)
                                        .toDate()
                                        .toString();

                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Activity Time: ${activityTime.split(' ')[0].split('-')[2]}/${activityTime.split(' ')[0].split('-')[1]}/${activityTime.split(' ')[0].split('-')[0]} ${activityTime.split(' ')[1].substring(0, 5)} ${int.parse(activityTime.split(' ')[1].substring(0, 2)) >= 12 ? 'PM' : 'AM'}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Details: ${activityData['activity_details']}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(height: 8),
                                        if (activityData['activity_picture']
                                            .isNotEmpty)
                                          Image.network(
                                              activityData['activity_picture']),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                      if (bookingData['booking_status'] == "Completed" &&
                          !isRated) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: MoonFilledButton(
                                buttonSize: MoonButtonSize.lg,
                                backgroundColor: const Color(0xFF9DC543),
                                onTap: () {
                                  showMoonModal<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Material(
                                        type: MaterialType.transparency,
                                        child: MoonModal(
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: SizedBox(
                                              height: 350,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  64,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        "Rating & Feedback",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      MoonOutlinedButton(
                                                        buttonSize:
                                                            MoonButtonSize.sm,
                                                        label: const Text("X"),
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  const Center(
                                                    child: Text(
                                                      "Please provide rating & feedback for the cleaning service.",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  CleanerRatingBar(
                                                    initialRating: rating,
                                                    onRatingChanged:
                                                        (newRating) {
                                                      setState(() {
                                                        rating = newRating;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(height: 16),
                                                  MoonTextArea(
                                                    height: 150,
                                                    hintText:
                                                        'Write your comments here...',
                                                    validator: (String?
                                                            value) =>
                                                        value != null &&
                                                                value.length < 5
                                                            ? "The text should be longer than 5 characters."
                                                            : null,
                                                    onChanged: (value) {
                                                      RatingController.instance
                                                          .updateReview(value);
                                                    },
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: MoonFilledButton(
                                                          label: const Text(
                                                              "Submit Rating"),
                                                          onTap: () async {
                                                            await RatingController
                                                                .instance
                                                                .addRating(
                                                                    context,
                                                                    widget
                                                                        .bookingId,
                                                                    rating,
                                                                    bookingData[
                                                                        'cleaner_id'],
                                                                    houseData[
                                                                        'owner_id'])
                                                                .then((_) {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const BottomNavigationMenu(
                                                                    initialIndex:
                                                                        1,
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                label: const Text("Rate Cleaner"),
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
