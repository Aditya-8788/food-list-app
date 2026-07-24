// TODO: Define customer entity.
import 'package:equatable/equatable.dart';

class CustomerEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final String address;

  const CustomerEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.address,
  });

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        phone,
        profileImage,
        address,
      ];
}