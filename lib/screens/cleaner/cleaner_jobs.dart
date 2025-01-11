import 'package:flutter/material.dart';
import 'package:hcms/controllers/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms/screens/cleaner/job_details.dart';
import 'package:hcms/screens/cleaner/update_cleaning_status.dart';
import 'package:moon_design/moon_design.dart';

class CleanerJobs extends StatefulWidget {
  @override
  _CleanerJobsState createState() => _CleanerJobsState();

  final user = UserController().currentUser!;
}

class _CleanerJobsState extends State<CleanerJobs> {
  int _selectedSegment = 0;

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 40, bottom: 25),
          child: Row(
            children: [
              Text(
                'Hi, ${widget.user.name}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
            'Cleaner Jobs',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MoonSegmentedControl(
                    segmentedControlSize: MoonSegmentedControlSize.sm,
                    isExpanded: true,
                    segments: List.generate(
                      3,
                      (int index) {
                        switch (index) {
                          case 0:
                            return const Segment(
                              label: Flexible(child: Text('Available')),
                            );
                          case 1:
                            return const Segment(
                              label: Flexible(child: Text('Ongoing')),
                            );
                          case 2:
                            return const Segment(
                              label: Flexible(child: Text('Completed')),
                            );
                          default:
                            return Segment(
                              label: Text('Tab${index + 1}'),
                            );
                        }
                      },
                    ),
                    onSegmentChanged: (index) {
                      setState(() {
                        _selectedSegment = index;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('bookings').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final bookings = snapshot.data!.docs.where((booking) {
                  switch (_selectedSegment) {
                    case 0:
                      return booking['booking_status'] == 'Pending';
                    case 1:
                      return booking['cleaner_id'] == widget.user.id &&
                          booking['booking_status'] != 'Completed';
                    case 2:
                      return booking['cleaner_id'] == widget.user.id &&
                          booking['booking_status'] == 'Completed';
                    default:
                      return false;
                  }
                }).toList();

                if (bookings.isEmpty) {
                  return const Center(child: Text('No Data Available'));
                }

                return ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    final houseId =
                        (booking['house_id'] as DocumentReference).id;
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('houses')
                          .doc(houseId)
                          .get(),
                      builder: (context, houseSnapshot) {
                        if (!houseSnapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final houseData = houseSnapshot.data!;
                        return JobCard(
                          jobId: booking.id,
                          houseId: houseId,
                          jobDateTime:
                              (booking['booking_datetime'] as Timestamp)
                                  .toDate()
                                  .toString(),
                          jobTotalCost: booking['booking_total_cost'],
                          houseName: houseData['house_name'],
                          houseImage: houseData['house_picture'],
                          houseAddress: houseData['house_address'],
                          jobStatus: booking['booking_status'],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final String jobId;
  final String houseId;
  final String jobDateTime;
  final double jobTotalCost;
  final String houseName;
  final String houseImage;
  final String houseAddress;
  final String jobStatus;

  const JobCard({
    super.key,
    required this.jobId,
    required this.houseId,
    required this.jobDateTime,
    required this.jobTotalCost,
    required this.houseName,
    required this.houseImage,
    required this.houseAddress,
    required this.jobStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => JobDetailsScreen(
                        bookingId: jobId,
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
                          : const NetworkImage(
                                  'https://cf.bstatic.com/xdata/images/hotel/max1024x768/518552029.jpg?k=9bd75fdc98262a98c60e10c80a56781bea4bcbca0b617b22315e4c58ae61a2bf&o=&hp=1')
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
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(MoonIcons.time_calendar_date_32_regular,
                              size: 24, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${jobDateTime.split(' ')[0].split('-')[2]}/${jobDateTime.split(' ')[0].split('-')[1]}/${jobDateTime.split(' ')[0].split('-')[0]} ${jobDateTime.split(' ')[1].substring(0, 5)} ${int.parse(jobDateTime.split(' ')[1].substring(0, 2)) >= 12 ? 'PM' : 'AM'}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(MoonIcons.travel_bed_32_regular,
                              size: 24, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '3 Rooms',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.payments,
                              size: 20, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                              'RM ${(jobTotalCost).toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(MoonIcons.generic_info_32_light,
                              size: 24, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            jobStatus == 'Pending'
                                ? 'Job Available'
                                : jobStatus == 'Completed'
                                    ? 'Job Completed'
                                    : jobStatus == 'Waiting for Payment'
                                        ? 'Waiting For Payment'
                                        : 'Job Ongoing',
                            style: TextStyle(
                              color: jobStatus == 'Pending'
                                  ? Colors.blue[700]
                                  : jobStatus == 'Completed'
                                      ? Colors.green[700]
                                      : jobStatus == 'Waiting For Payment'
                                          ? Colors.red[700]
                                          : Colors.orange[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (jobStatus == "Assigned" || jobStatus == "Waiting for Payment")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: MoonFilledButton(
                              backgroundColor: const Color(0xFF9DC543),
                              buttonSize: MoonButtonSize.lg,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateCleaningStatusScreen(
                                      bookingId: jobId,
                                    ),
                                  ),
                                );
                              },
                              label: const Text("Update Progress"),
                            ),
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
      ],
    );
  }
}
