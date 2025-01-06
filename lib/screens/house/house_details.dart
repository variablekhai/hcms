import 'package:flutter/material.dart';
import 'edit_house.dart';

class HouseDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> house;

  HouseDetailsScreen({required this.house});

  @override
  _HouseDetailsScreenState createState() => _HouseDetailsScreenState();
}

class _HouseDetailsScreenState extends State<HouseDetailsScreen> {
  late Map<String, dynamic> house;

  @override
  void initState() {
    super.initState();
    house = widget.house; // Initialize with the passed house data
  }

  void _editHouse() async {
    // Navigate to the EditHouseScreen and wait for updated house data
    final updatedHouse = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditHouseScreen(house: house),
      ),
    );

    if (updatedHouse != null) {
      setState(() {
        house = updatedHouse; // Update house details
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('House Details', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // House Image
          SizedBox(
            height: 200,
            child: PageView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(house['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          // House Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  house['address'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Size: ${house['size']}'),
                SizedBox(height: 5),
                Text('Number of Rooms: ${house['rooms']}'),
                SizedBox(height: 5),
                Text(
                  'Special Notes: ${house['notes']}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: _editHouse, // Navigate to EditHouseScreen
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Delete button tapped')),
                    );
                  },
                ),
              ],
            ),
          ),
          // "Book a Cleaner" Button
          Center(
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Book a Cleaner button tapped')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Book a Cleaner',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
