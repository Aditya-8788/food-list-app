// TODO: Implement auth repository implementation.
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity?> getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) {
    return remoteDataSource.login(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserEntity> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) {
    return remoteDataSource.signup(
      name: name,
      email: email,
      password: password,
      phone: phone,
      role: role,
    );
  }

  @override
  Future<void> saveUserRole({
    required String uid,
    required String role,
  }) {
    return remoteDataSource.saveUserRole(
      uid: uid,
      role: role,
    );
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }
  
}