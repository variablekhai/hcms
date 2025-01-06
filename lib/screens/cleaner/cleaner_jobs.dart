import 'package:flutter/material.dart';
import 'package:hcms/screens/booking/add_booking.dart';
import 'package:hcms/screens/booking/booking_details.dart';
import 'package:hcms/screens/booking/widgets/filters_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moon_design/moon_design.dart';

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
          'Cleaner Jobs',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}

class SegmentedControl extends StatelessWidget {
  const SegmentedControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
      ),
    );
  }
}

class CleanerJobs extends StatelessWidget {
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
              Expanded(child: const SegmentedControl()),
            ],
            ),
            const SizedBox(height: 10),
            Expanded(
            child: ListView(
              children: [
              JobCard(
                jobId: 'job1',
                houseId: 'house1',
                jobDateTime: '2023-10-01 14:00:00',
                jobTotalCost: 150.00,
              ),
              JobCard(
                jobId: 'job2',
                houseId: 'house2',
                jobDateTime: '2023-10-02 10:00:00',
                jobTotalCost: 200.00,
              ),
              JobCard(
                jobId: 'job3',
                houseId: 'house3',
                jobDateTime: '2023-10-03 16:00:00',
                jobTotalCost: 180.00,
              ),
              ],
            ),
            ),
          // Add more widgets here
        ],
      ),
    );
  }
}

class JobCard extends StatefulWidget {
  final String jobId;
  final String houseId;
  final String jobDateTime;
  final double jobTotalCost;

  const JobCard({
    super.key,
    required this.jobId,
    required this.houseId,
    required this.jobDateTime,
    required this.jobTotalCost,
  });

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  String houseName = '';
  String houseImage = '';
  String houseAddress = '';

  Future<DocumentSnapshot> getHouseData(String houseId) async {
    return await FirebaseFirestore.instance.collection('houses').doc(houseId).get();
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
              MaterialPageRoute(builder: (context) => BookingDetails(
                bookingId: widget.jobId,
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
                          : const NetworkImage('https://cf.bstatic.com/xdata/images/hotel/max1024x768/518552029.jpg?k=9bd75fdc98262a98c60e10c80a56781bea4bcbca0b617b22315e4c58ae61a2bf&o=&hp=1') as ImageProvider,
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
                        'My Villa',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                        Row(
                        children: [
                          const Icon(MoonIcons.time_calendar_date_32_regular, size: 24, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                          '${widget.jobDateTime.split(' ')[0].split('-')[2]}/${widget.jobDateTime.split(' ')[0].split('-')[1]}/${widget.jobDateTime.split(' ')[0].split('-')[0]} ${widget.jobDateTime.split(' ')[1].substring(0, 5)} ${int.parse(widget.jobDateTime.split(' ')[1].substring(0, 2)) >= 12 ? 'PM' : 'AM'}',
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
                            '3 Bedrooms 2 Bathrooms',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.payments, size: 20, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            'RM 25/hr',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(MoonIcons.generic_info_32_light, size: 24, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'Job Available',
                            style: TextStyle(color: Colors.blue[700]),
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