import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/hotel_entity.dart';

class HotelModel extends HotelEntity {
  const HotelModel({
    required super.hotelId,
    required super.ownerId,
    required super.hotelName,
    required super.ownerName,
    required super.email,
    required super.phone,
    required super.address,
    required super.hotelImage,
    required super.isOpen,
    required super.rating,
  });

  factory HotelModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return HotelModel(
      hotelId: doc.id,
      ownerId: data['ownerId'] ?? '',
      hotelName: data['hotelName'] ?? '',
      ownerName: data['ownerName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      hotelImage: data['hotelImage'] ?? '',
      isOpen: data['isOpen'] ?? true,
      rating: (data['rating'] ?? 0).toDouble(),
    );
  }

  factory HotelModel.fromEntity(HotelEntity hotel) {
    return HotelModel(
      hotelId: hotel.hotelId,
      ownerId: hotel.ownerId,
      hotelName: hotel.hotelName,
      ownerName: hotel.ownerName,
      email: hotel.email,
      phone: hotel.phone,
      address: hotel.address,
      hotelImage: hotel.hotelImage,
      isOpen: hotel.isOpen,
      rating: hotel.rating,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'hotelName': hotelName,
      'ownerName': ownerName,
      'email': email,
      'phone': phone,
      'address': address,
      'hotelImage': hotelImage,
      'isOpen': isOpen,
      'rating': rating,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}