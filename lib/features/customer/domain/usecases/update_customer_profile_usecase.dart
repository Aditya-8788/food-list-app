// TODO: Implement update customer profile use case.
import '../repositories/customer_repository.dart';

class UpdateCustomerProfileUseCase {
  final CustomerRepository repository;

  UpdateCustomerProfileUseCase(this.repository);

  Future<void> call({
    required String uid,
    required String name,
    required String phone,
    required String address,
  }) {
    return repository.updateCustomerProfile(
      uid: uid,
      name: name,
      phone: phone,
      address: address,
    );
  }
}