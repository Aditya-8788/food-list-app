// TODO: Implement hotel BLoC.
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_hotel_profile_usecase.dart';
import '../../domain/usecases/get_hotel_profile_usecase.dart';
import '../../domain/usecases/update_hotel_profile_usecase.dart';
import 'hotel_event.dart';
import 'hotel_state.dart';

class HotelBloc extends Bloc<HotelEvent, HotelState> {
  final CreateHotelProfileUseCase createHotelProfileUseCase;
  final GetHotelProfileUseCase getHotelProfileUseCase;
  final UpdateHotelProfileUseCase updateHotelProfileUseCase;

  HotelBloc({
    required this.createHotelProfileUseCase,
    required this.getHotelProfileUseCase,
    required this.updateHotelProfileUseCase,
  }) : super(HotelInitial()) {
    on<GetHotelProfileRequested>(_onGetHotelProfile);
    on<CreateHotelProfileRequested>(_onCreateHotelProfile);
    on<UpdateHotelProfileRequested>(_onUpdateHotelProfile);
  }

  Future<void> _onGetHotelProfile(
    GetHotelProfileRequested event,
    Emitter<HotelState> emit,
  ) async {
    emit(HotelLoading());

    try {
      final hotel = await getHotelProfileUseCase(event.ownerId);

      if (hotel == null) {
        emit(HotelNotCreated());
      } else {
        emit(HotelLoaded(hotel));
      }
    } catch (e) {
      emit(HotelError(e.toString()));
    }
  }

  Future<void> _onCreateHotelProfile(
    CreateHotelProfileRequested event,
    Emitter<HotelState> emit,
  ) async {
    emit(HotelLoading());

    try {
      await createHotelProfileUseCase(event.hotel);
      emit(const HotelActionSuccess('Hotel profile created successfully'));

      final hotel = await getHotelProfileUseCase(event.hotel.ownerId);
      if (hotel != null) {
        emit(HotelLoaded(hotel));
      }
    } catch (e) {
      emit(HotelError(e.toString()));
    }
  }

  Future<void> _onUpdateHotelProfile(
    UpdateHotelProfileRequested event,
    Emitter<HotelState> emit,
  ) async {
    emit(HotelLoading());

    try {
      await updateHotelProfileUseCase(event.hotel);
      emit(const HotelActionSuccess('Hotel profile updated successfully'));

      final hotel = await getHotelProfileUseCase(event.hotel.ownerId);
      if (hotel != null) {
        emit(HotelLoaded(hotel));
      }
    } catch (e) {
      emit(HotelError(e.toString()));
    }
  }
}