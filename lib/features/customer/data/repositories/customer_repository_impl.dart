// TODO: Implement customer repository implementation.
import '../../domain/entities/customer_entity.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasource/customer_remote_datasource.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource remoteDataSource;

  CustomerRepositoryImpl(this.remoteDataSource);

  @override
  Future<CustomerEntity> getCustomerProfile(String uid) {
    return remoteDataSource.getCustomerProfile(uid);
  }

  @override
  Future<void> updateCustomerProfile({
    required String uid,
    required String name,
    required String phone,
    required String address,
  }) {
    return remoteDataSource.updateCustomerProfile(
      uid: uid,
      name: name,
      phone: phone,
      address: address,
    );
  }
}