// TODO: Define customer repository contract.
import '../entities/customer_entity.dart';

abstract class CustomerRepository {
  Future<CustomerEntity> getCustomerProfile(String uid);

  Future<void> updateCustomerProfile({
    required String uid,
    required String name,
    required String phone,
    required String address,
  });
}