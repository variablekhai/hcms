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
      'name': 'Luxury House',
      'address': '123 Main Street, KL',
      'rooms': '4 Rooms',
      'size': '1500 sq ft',
      'notes': 'Spacious house with amenities.',
    },
    {
      'image': 'assets/house2.jpg',
      'name': 'Modern Villa',
      'address': '456 Elm Avenue, Penang',
      'rooms': '3 Rooms',
      'size': '1200 sq ft',
      'notes': 'Modern house with garden.',
    },
    {
      'image': 'assets/house3.jpg',
      'name': 'Family Home',
      'address': '789 Oak Lane, JB',
      'rooms': '5 Rooms',
      'size': '1800 sq ft',
      'notes': 'Luxury villa with pool.',
    },
  ];

  // Function to add a new house
  void _addNewHouse(Map<String, dynamic> newHouse) {
    setState(() {
      houses.add(newHouse);
    });
  }

  // Function to update an existing house
  void _updateHouse(int index, Map<String, dynamic> updatedHouse) {
    setState(() {
      houses[index] = updatedHouse;
    });
  }

  // Function to delete a house
  void _deleteHouse(int index) {
    setState(() {
      houses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: AppBar(
        title: Text('House List', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Filter feature not implemented yet!')),
              );
            },
          ),
        ],
      ),

      // Body Section
      body: Column(
        children: [
          // Search Bar
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
                    onTap: () async {
                      // Navigate to House Details Screen
                      final updatedHouse = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HouseDetailsScreen(
                            house: houses[index],
                          ),
                        ),
                      );

                      // If updated house data is returned, update the list
                      if (updatedHouse != null) {
                        _updateHouse(index, updatedHouse);
                      }
                    },
                    leading: Image.asset(
                      houses[index]['image'],
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      houses[index]['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${houses[index]['rooms']} - ${houses[index]['size']}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteHouse(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Floating Action Button to Add House
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
    );
  }
}
