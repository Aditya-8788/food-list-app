// TODO: Define auth repository contract.
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> getCurrentUser();

  Future<UserEntity> login({
    required String email,
    required String password,
  });

  Future<UserEntity> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  });

  // Future<UserEntity> googleLogin();

  Future<void> saveUserRole({
    required String uid,
    required String role,
  });

  Future<void> logout();
}