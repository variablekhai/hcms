import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms/screens/booking/add_booking.dart';
import 'package:moon_design/moon_design.dart';
import 'edit_house.dart';

class HouseDetailsScreen extends StatefulWidget {
  final String houseId;

  HouseDetailsScreen({required this.houseId});

  @override
  _HouseDetailsScreenState createState() => _HouseDetailsScreenState();
}

class _HouseDetailsScreenState extends State<HouseDetailsScreen> {
  late DocumentReference houseRef;

  @override
  void initState() {
    super.initState();
    houseRef =
        FirebaseFirestore.instance.collection('houses').doc(widget.houseId);
  }

  void _editHouse(Map<String, dynamic> houseData) async {
    final updatedHouse = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditHouseScreen(houseData: houseData),
      ),
    );

    if (updatedHouse != null) {
      setState(() {
        houseRef =
            FirebaseFirestore.instance.collection('houses').doc(widget.houseId);
      });
    }
  }

  void _deleteHouse() {
    showMoonModal<void>(
      context: context,
      builder: (BuildContext context) {
        return MoonModal(
          child: SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width - 64,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Are you sure you want to delete this house?"),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: MoonFilledButton(
                          label: const Text("Yes"),
                          backgroundColor: const Color(0xFF9DC543),
                          onTap: () async {
                            await houseRef.delete();

                            MoonToast.show(
                              context,
                              backgroundColor: Colors.green[50],
                              leading: Icon(
                                MoonIcons.time_calendar_success_24_regular,
                                color: Colors.green[700],
                              ),
                              label: Text(
                                'House successfully deleted',
                                style: TextStyle(color: Colors.green[700]),
                              ),
                            );
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MoonOutlinedButton(
                          label: const Text("No"),
                          onTap: () {
                            Navigator.of(context).pop();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: houseRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('House not found'));
          }

          var houseData = snapshot.data!.data() as Map<String, dynamic>;
          houseData['id'] = widget.houseId;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
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
                  'House Details',
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
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.home, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'House Name: ${houseData['house_name']}',
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
                                    const Icon(Icons.location_pin,
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
                                    const Icon(Icons.square_foot,
                                        color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'Size: ${houseData['house_size']}',
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
                                const SizedBox(height: 8),
                              ],
                            ),
                          )
                        ],
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Row(
                          children: [
                            FloatingActionButton(
                              mini: true,
                              onPressed: () => _editHouse(houseData),
                              backgroundColor:const Color(0xFF9DC543),
                              child: const Icon(Icons.edit, color: Colors.white),
                            ),
                            const SizedBox(width: 4),
                            FloatingActionButton(
                              mini: true,
                              onPressed: _deleteHouse,
                              backgroundColor:const Color(0xFF9DC543),
                                child: const Icon(Icons.delete, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                        builder: (context) => AddBookingScreen(houseId: widget.houseId),
                      ),
                      );
                    },
                    label: const Text("Book a Cleaner"),
                    ),
                  ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
