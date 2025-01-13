// lib/controllers/house_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import '../../models/house_model.dart';

class HouseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get houses stream for a specific owner
  Stream<List<House>> getHousesStream(String? ownerId) {
    return _firestore
        .collection('houses')
        .where('owner_id', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => House.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Get single house
  Future<House?> getHouse(String houseId) async {
    final doc = await _firestore.collection('houses').doc(houseId).get();
    if (doc.exists) {
      return House.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  // Add new house
  Future<void> addHouse(House house) async {
    await _firestore.collection('houses').add(house.toMap());
  }

  // Update house
  Future<void> updateHouse(String houseId, House house) async {
    await _firestore.collection('houses').doc(houseId).update(house.toMap());
  }

  // Delete house
  Future<void> deleteHouse(String houseId) async {
    await _firestore.collection('houses').doc(houseId).delete();
  }

  // Upload house image
  Future<String> uploadHouseImage(Uint8List imageBytes) async {
    final storageRef = _storage
        .ref()
        .child('house_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = storageRef.putData(imageBytes);
    final snapshot = await uploadTask.whenComplete(() => {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl.replaceFirst('download', 'view');
  }
}