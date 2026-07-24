// TODO: Implement customer BLoC.
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_customer_profile_usecase.dart';
import '../../domain/usecases/update_customer_profile_usecase.dart';
import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetCustomerProfileUseCase getCustomerProfileUseCase;
  final UpdateCustomerProfileUseCase updateCustomerProfileUseCase;

  CustomerBloc({
    required this.getCustomerProfileUseCase,
    required this.updateCustomerProfileUseCase,
  }) : super(CustomerInitial()) {
    on<GetCustomerProfileRequested>(_onGetCustomerProfile);
    on<UpdateCustomerProfileRequested>(_onUpdateCustomerProfile);
  }

  Future<void> _onGetCustomerProfile(
    GetCustomerProfileRequested event,
    Emitter<CustomerState> emit,
  ) async {
    emit(CustomerLoading());

    try {
      final customer = await getCustomerProfileUseCase(event.uid);
      emit(CustomerLoaded(customer));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> _onUpdateCustomerProfile(
    UpdateCustomerProfileRequested event,
    Emitter<CustomerState> emit,
  ) async {
    emit(CustomerLoading());

    try {
      await updateCustomerProfileUseCase(
        uid: event.uid,
        name: event.name,
        phone: event.phone,
        address: event.address,
      );

      emit(CustomerUpdated());

      final customer = await getCustomerProfileUseCase(event.uid);
      emit(CustomerLoaded(customer));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }
}