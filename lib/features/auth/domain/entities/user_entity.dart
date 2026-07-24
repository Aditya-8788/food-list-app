// TODO: Define user entity.
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String profileImage;
  final String authProvider;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.profileImage,
    required this.authProvider,
  });

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        phone,
        role,
        profileImage,
        authProvider,
      ];
}