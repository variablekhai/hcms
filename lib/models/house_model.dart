class House {
  final String? id;
  final String housePicture;
  final String houseName;
  final String houseAddress;
  final String houseSize;
  final String numberOfRooms;
  final String? ownerId;

  House({
    this.id,
    required this.housePicture,
    required this.houseName,
    required this.houseAddress,
    required this.houseSize,
    required this.numberOfRooms,
    required this.ownerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'house_picture': housePicture,
      'house_name': houseName,
      'house_address': houseAddress,
      'house_size': houseSize,
      'house_no_of_rooms': numberOfRooms,
      'owner_id': ownerId,
    };
  }

  factory House.fromMap(Map<String, dynamic> map, String id) {
    return House(
      id: id,
      housePicture: map['house_picture'] ?? '',
      houseName: map['house_name'] ?? '',
      houseAddress: map['house_address'] ?? '',
      houseSize: map['house_size'] ?? '',
      numberOfRooms: map['house_no_of_rooms'] ?? '',
      ownerId: map['owner_id'] ?? '',
    );
  }
}