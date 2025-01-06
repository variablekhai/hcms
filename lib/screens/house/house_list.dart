import 'package:flutter/material.dart';
import 'house_details.dart';
import 'add_house.dart';

class HouseListScreen extends StatefulWidget {
  @override
  _HouseListScreenState createState() => _HouseListScreenState();
}

class _HouseListScreenState extends State<HouseListScreen> {
  // Initial list of houses
  List<Map<String, dynamic>> houses = [
    {
      'image': 'assets/house1.jpg',
      'address': '123 Main Street, KL',
      'rooms': '4 Rooms',
      'size': '1500 sq ft',
      'notes': 'Spacious house with amenities.',
    },
    {
      'image': 'assets/house2.jpg',
      'address': '456 Elm Avenue, Penang',
      'rooms': '3 Rooms',
      'size': '1200 sq ft',
      'notes': 'Modern house with garden.',
    },
    {
      'image': 'assets/house3.jpg',
      'address': '789 Oak Lane, JB',
      'rooms': '5 Rooms',
      'size': '1800 sq ft',
      'notes': 'Luxury villa with pool.',
    },
  ];

  // Function to add a new house
  void _addNewHouse(Map<String, dynamic> newHouse) {
    setState(() {
      houses.add(newHouse); // Add new house to the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('House List', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              // Add filter logic here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search houses...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          // House List
          Expanded(
            child: ListView.builder(
              itemCount: houses.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    onTap: () {
                      // Navigate to House Details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HouseDetailsScreen(house: houses[index]),
                        ),
                      );
                    },
                    leading: Image.asset(
                      houses[index]['image'],
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                    title: Text(houses[index]['address']),
                    subtitle: Text(houses[index]['rooms']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          houses.removeAt(index); // Delete house
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to Add House Screen
          final newHouse = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddHouseScreen()),
          );

          // If a new house is returned, add it to the list
          if (newHouse != null) {
            _addNewHouse(newHouse);
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'House',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
