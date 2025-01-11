import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateCleaningStatusScreen extends StatefulWidget {
  final String bookingId;

  UpdateCleaningStatusScreen({required this.bookingId});

  @override
  _UpdateCleaningStatusScreenState createState() =>
      _UpdateCleaningStatusScreenState();
}

class _UpdateCleaningStatusScreenState
    extends State<UpdateCleaningStatusScreen> {
  Uint8List? _imagePath;
  String? _imageUrl;
  bool _isUploading = false;
  TextEditingController _commentsController = TextEditingController();
  bool _isJobCompleted = false;

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
          SnackBar(content: Text('Image Uploaded Successfully!')),
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

  Future<void> _submitUpdate() async {
    if (_commentsController.text.isEmpty || _imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide comments and upload an image.')),
      );
      return;
    }

    final activityData = {
      'booking_id': FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingId),
      'activity_start_time': DateTime.now(),
      'activity_details': _commentsController.text,
      'activity_picture': _imageUrl,
    };

    try {
      await FirebaseFirestore.instance
          .collection('cleaningactivity')
          .add(activityData);

      if (_isJobCompleted) {
        await FirebaseFirestore.instance
            .collection('bookings')
            .doc(widget.bookingId)
            .update({'booking_status': 'Waiting for Payment'});
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cleaning activity updated successfully!')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update cleaning activity: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 25, right: 25, top: 40, bottom: 25),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(MoonIcons.arrows_left_24_regular),
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
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Update Cleaning Status',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
                alignment: Alignment.centerLeft,
                child: Text('Booking ID: ${widget.bookingId}')),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                                  ),
                                )
                              : const Icon(MoonIcons.generic_upload_32_light),
                          onTap: _uploadImage,
                          label: const Text("Upload Image"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    MoonTextArea(
                      height: 200,
                      controller: _commentsController,
                      hintText: 'Write your comments here...',
                      validator: (String? value) =>
                          value != null && value.length < 5
                              ? "The text should be longer than 5 characters."
                              : null,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        MoonCheckbox(
                          value: _isJobCompleted,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _isJobCompleted = newValue!;
                            });
                          },
                        ),
                        const Text('Mark Job as Completed'),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: MoonFilledButton(
                            buttonSize: MoonButtonSize.lg,
                            backgroundColor: const Color(0xFF9DC543),
                            onTap: _submitUpdate,
                            label: const Text("Submit Update"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
