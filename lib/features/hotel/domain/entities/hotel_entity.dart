// TODO: Define hotel entity.
import 'package:equatable/equatable.dart';

class HotelEntity extends Equatable {
  final String hotelId;
  final String ownerId;
  final String hotelName;
  final String ownerName;
  final String email;
  final String phone;
  final String address;
  final String hotelImage;
  final bool isOpen;
  final double rating;

  const HotelEntity({
    required this.hotelId,
    required this.ownerId,
    required this.hotelName,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.address,
    required this.hotelImage,
    required this.isOpen,
    required this.rating,
  });

  @override
  List<Object?> get props => [
        hotelId,
        ownerId,
        hotelName,
        ownerName,
        email,
        phone,
        address,
        hotelImage,
        isOpen,
        rating,
      ];
}