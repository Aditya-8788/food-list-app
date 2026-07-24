// TODO: Define customer events.
import 'package:equatable/equatable.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object?> get props => [];
}

class GetCustomerProfileRequested extends CustomerEvent {
  final String uid;

  const GetCustomerProfileRequested(this.uid);

  @override
  List<Object?> get props => [uid];
}

class UpdateCustomerProfileRequested extends CustomerEvent {
  final String uid;
  final String name;
  final String phone;
  final String address;

  const UpdateCustomerProfileRequested({
    required this.uid,
    required this.name,
    required this.phone,
    required this.address,
  });

  @override
  List<Object?> get props => [
        uid,
        name,
        phone,
        address,
      ];
}