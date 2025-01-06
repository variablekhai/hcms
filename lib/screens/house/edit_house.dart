import 'package:flutter/material.dart';

class EditHouseScreen extends StatefulWidget {
  final Map<String, dynamic> house;

  EditHouseScreen({required this.house});

  @override
  _EditHouseScreenState createState() => _EditHouseScreenState();
}

class _EditHouseScreenState extends State<EditHouseScreen> {
  late TextEditingController _houseNameController;
  late TextEditingController _addressController;
  late TextEditingController _sizeController;
  late TextEditingController _roomsController;
  late TextEditingController _notesController;

  // Image placeholder
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _houseNameController =
        TextEditingController(text: widget.house['name'] ?? '');
    _addressController =
        TextEditingController(text: widget.house['address'] ?? '');
    _sizeController =
        TextEditingController(text: widget.house['size']?.split(' ')[0] ?? '');
    _roomsController =
        TextEditingController(text: widget.house['rooms']?.split(' ')[0] ?? '');
    _notesController = TextEditingController(text: widget.house['notes'] ?? '');

    _imagePath = widget.house['image'];
  }

  @override
  void dispose() {
    _houseNameController.dispose();
    _addressController.dispose();
    _sizeController.dispose();
    _roomsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _uploadImage() {
    setState(() {
      _imagePath = 'assets/house_placeholder.jpg'; // Simulated upload
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image Uploaded Successfully!')),
    );
  }

  void _updateHouse() {
    // Create the updated house map
    Map<String, dynamic> updatedHouse = {
      'image': _imagePath ?? 'assets/house_placeholder.jpg',
      'name': _houseNameController.text,
      'address': _addressController.text,
      'size': '${_sizeController.text} sq ft',
      'rooms': '${_roomsController.text} Rooms',
      'notes': _notesController.text,
    };

    Navigator.pop(
        context, updatedHouse); // Return updated data to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit House', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
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

            // Cancel and Update Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context), // Cancel
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _updateHouse, // Update
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text('Update', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
