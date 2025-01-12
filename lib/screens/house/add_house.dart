import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hcms/controllers/user_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moon_design/moon_design.dart';

class AddHouseScreen extends StatefulWidget {
  AddHouseScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddHouseScreenState createState() => _AddHouseScreenState();

  final user = UserController().currentUser!;
}

class _AddHouseScreenState extends State<AddHouseScreen> {
  final TextEditingController _houseNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Uint8List? _imagePath;
  String? _imageUrl;
  bool _isUploading = false;

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();

      setState(() {
        _imagePath = bytes;
        _isUploading = true;
      });

      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('house_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = storageRef.putData(bytes);
        final snapshot = await uploadTask.whenComplete(() => {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          _imageUrl = downloadUrl.replaceFirst('download', 'view');
          _isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image Uploaded Successfully!')),
        );
      } catch (e) {
        setState(() {
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> newHouse = {
        'house_picture': _imageUrl ?? 'assets/house-placeholder.png',
        'house_name': _houseNameController.text,
        'house_address': _addressController.text,
        'house_size': '${_sizeController.text} sq ft',
        'house_no_of_rooms': '${_roomsController.text} Rooms',
        'owner_id': widget.user.id,
      };

      FirebaseFirestore.instance.collection('houses').add(newHouse).then((_) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('House added successfully!')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add house: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                const SizedBox(height: 20),
                const Text(
                  'Add House',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Please fill in all details of the house',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      _imagePath != null
                          ? Image.memory(
                              _imagePath!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : const Center(
                              child: Icon(
                                Icons.image,
                                size: 80,
                                color: Colors.grey,
                              ),
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MoonFilledButton(
                      buttonSize: MoonButtonSize.lg,
                      backgroundColor: const Color(0xFF9DC543),
                      leading: _isUploading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            )
                          : const Icon(MoonIcons.generic_upload_32_light),
                      onTap: _uploadImage,
                      label: const Text("Upload Image"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                MoonFormTextInput(
                  controller: _houseNameController,
                  validator: (String? value) => value != null && value.isEmpty
                      ? 'Please enter house name'
                      : null,
                  leading: const Icon(Icons.home),
                  hintText: 'House Name',
                  textInputSize: MoonTextInputSize.lg,
                ),
                const SizedBox(height: 10),
                MoonFormTextInput(
                  controller: _addressController,
                  validator: (String? value) => value != null && value.isEmpty
                      ? 'Please enter address'
                      : null,
                  leading: const Icon(Icons.location_on),
                  hintText: 'Address',
                  textInputSize: MoonTextInputSize.lg,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: MoonFormTextInput(
                        controller: _sizeController,
                        validator: (String? value) =>
                            value != null && value.isEmpty
                                ? 'Please enter size'
                                : null,
                        leading: const Icon(Icons.square_foot),
                        trailing: const Center(child: Text('sq ft')),
                        hintText: 'Size',
                        textInputSize: MoonTextInputSize.lg,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MoonFormTextInput(
                        controller: _roomsController,
                        validator: (String? value) =>
                            value != null && value.isEmpty
                                ? 'Please enter number of rooms'
                                : null,
                        leading: const Icon(Icons.meeting_room),
                        hintText: 'No. of Rooms',
                        textInputSize: MoonTextInputSize.lg,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: MoonOutlinedButton(
                        buttonSize: MoonButtonSize.lg,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        label: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MoonFilledButton(
                        buttonSize: MoonButtonSize.lg,
                        backgroundColor: const Color(0xFF9DC543),
                        onTap: _submitForm,
                        label: const Text("Add House"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
