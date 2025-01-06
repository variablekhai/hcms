import 'package:flutter/material.dart';

class AddHouseScreen extends StatefulWidget {
  @override
  _AddHouseScreenState createState() => _AddHouseScreenState();
}

class _AddHouseScreenState extends State<AddHouseScreen> {
  // Controllers for input fields
  final TextEditingController _houseNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Image placeholder (URL or local file)
  String? _imagePath;

  // Function to simulate image upload
  void _uploadImage() {
    setState(() {
      _imagePath =
          'assets/house_placeholder.jpg'; // Replace with actual upload logic
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image Uploaded Successfully!')),
    );
  }

  // Function to handle form submission
  void _submitForm() {
    if (_houseNameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _sizeController.text.isEmpty ||
        _roomsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    } else {
      // Create new house object
      Map<String, dynamic> newHouse = {
        'image': _imagePath ?? 'assets/house_placeholder.jpg', // Default image
        'name': _houseNameController.text,
        'address': _addressController.text,
        'size': '${_sizeController.text} sq ft',
        'rooms': '${_roomsController.text} Rooms',
        'notes': _notesController.text,
      };

      Navigator.pop(
          context, newHouse); // Return the new house to previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Add House', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Upload Section
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _imagePath != null
                  ? Image.asset(_imagePath!, fit: BoxFit.cover)
                  : Center(
                      child: Icon(Icons.image, size: 80, color: Colors.grey)),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton.icon(
                onPressed: _uploadImage,
                icon: Icon(Icons.upload_file, color: Colors.white),
                label: Text('Upload Image'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ),

            SizedBox(height: 20),

            // Input Fields
            TextField(
              controller: _houseNameController,
              decoration: InputDecoration(
                labelText: 'House Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _sizeController,
                    decoration: InputDecoration(
                      labelText: 'Size',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _roomsController,
                    decoration: InputDecoration(
                      labelText: 'No. of Rooms',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Special Notes',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // Cancel and Submit Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cancel button
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text('Cancel', style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text('Submit', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
