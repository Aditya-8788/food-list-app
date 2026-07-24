// TODO: Define auth events.
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthSignupRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String role;

  const AuthSignupRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        phone,
        role,
      ];
}

// class AuthGoogleLoginRequested extends AuthEvent {}

class AuthSaveRoleRequested extends AuthEvent {
  final String uid;
  final String role;

  const AuthSaveRoleRequested({
    required this.uid,
    required this.role,
  });

  @override
  List<Object?> get props => [uid, role];
}

class AuthLogoutRequested extends AuthEvent {}