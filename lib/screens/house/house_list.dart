import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'house_details.dart';
import 'add_house.dart';

Widget _buildHeader() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 25, right: 25, top: 40, bottom: 25),
        child: Row(
          children: [
            Text(
              'Hi, Sandhiya ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5),
            Image.asset(
              'assets/wave.png',
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
      Padding(
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
  _HouseListScreenState createState() => _HouseListScreenState();
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
                prefixIcon: Icon(Icons.search),
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('houses').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final houses = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  data['id'] = doc.id;
                  return data;
                }).toList();
                return ListView.builder(
                  itemCount: houses.length,
                  itemBuilder: (context, index) {
                    return HouseCard(
                      house: houses[index],
                    );
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
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class HouseCard extends StatelessWidget {
  final Map<String, dynamic> house;

  const HouseCard({
    super.key,
    required this.house,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final updatedHouse = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HouseDetailsScreen(
              houseId: house['id'],
            ),
          ),
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
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: NetworkImage(house['house_picture']),
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
                    house['house_name'],
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
                        house['house_address'],
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
                        house['house_no_of_rooms'],
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
                        house['house_size'],
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
