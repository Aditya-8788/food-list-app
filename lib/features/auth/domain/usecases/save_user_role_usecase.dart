import '../repositories/auth_repository.dart';

class SaveUserRoleUseCase {
  final AuthRepository repository;

  SaveUserRoleUseCase(this.repository);

  Future<void> call({
    required String uid,
    required String role,
  }) {
    return repository.saveUserRole(
      uid: uid,
      role: role,
    );
  }
}