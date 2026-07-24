// TODO: Define customer states.
import 'package:equatable/equatable.dart';

import '../../domain/entities/customer_entity.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object?> get props => [];
}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final CustomerEntity customer;

  const CustomerLoaded(this.customer);

  @override
  List<Object?> get props => [customer];
}

class CustomerUpdated extends CustomerState {}

class CustomerError extends CustomerState {
  final String message;

  const CustomerError(this.message);

  @override
  List<Object?> get props => [message];
}