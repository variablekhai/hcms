import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms/controllers/house/house_controller.dart';
import 'package:hcms/controllers/user_controller.dart';
import 'package:hcms/models/house_model.dart';
import 'house_details.dart';
import 'add_house.dart';

Widget _buildHeader() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding:
            const EdgeInsets.only(left: 25, right: 25, top: 40, bottom: 25),
        child: Row(
          children: [
            Text(
              'Hi, ${UserController().currentUser!.name}',
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
          'My Houses',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}

class HouseListScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _HouseListScreenState createState() => _HouseListScreenState();

  final user = UserController().currentUser!;
  final _houseController = HouseController();

  HouseListScreen({super.key});
}

class _HouseListScreenState extends State<HouseListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search houses...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<House>>(
              stream: widget._houseController.getHousesStream(widget.user.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final houses = snapshot.data ?? [];
                if (houses.isEmpty) {
                  return const Center(child: Text('Start by adding a house'));
                }

                return ListView.builder(
                  itemCount: houses.length,
                  itemBuilder: (context, index) {
                    return HouseCard(house: houses[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newHouse = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddHouseScreen()),
          );

          if (newHouse != null) {
            FirebaseFirestore.instance.collection('houses').add(newHouse);
          }
        },
        backgroundColor: const Color(0xFF9DC543),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class HouseCard extends StatelessWidget {
  final House house;

  const HouseCard({
    super.key,
    required this.house,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HouseDetailsScreen(
              houseId: house.id,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(left: 25, right: 25, bottom: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: NetworkImage(house.housePicture),
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
                    house.houseName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey[700]),
                      const SizedBox(width: 4),
                      Text(
                        house.houseAddress,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.king_bed, color: Colors.grey[700]),
                      const SizedBox(width: 4),
                      Text(
                        house.numberOfRooms.toString(),
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.square_foot, color: Colors.grey[700]),
                      const SizedBox(width: 4),
                      Text(
                        house.houseSize.toString(),
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
    );
  }
}
