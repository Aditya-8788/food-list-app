// TODO: Implement get customer profile use case.
import '../entities/customer_entity.dart';
import '../repositories/customer_repository.dart';

class GetCustomerProfileUseCase {
  final CustomerRepository repository;

  GetCustomerProfileUseCase(this.repository);

  Future<CustomerEntity> call(String uid) {
    return repository.getCustomerProfile(uid);
  }
}