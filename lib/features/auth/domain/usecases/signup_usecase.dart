// TODO: Implement signup use case.
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<UserEntity> call({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) {
    return repository.signup(
      name: name,
      email: email,
      password: password,
      phone: phone,
      role: role,
    );
  }
}