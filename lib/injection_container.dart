import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

// Auth
import 'features/auth/data/datasource/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/save_user_role_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Customer
import 'features/customer/data/datasource/customer_remote_datasource.dart';
import 'features/customer/data/repositories/customer_repository_impl.dart';
import 'features/customer/domain/repositories/customer_repository.dart';
import 'features/customer/domain/usecases/get_customer_profile_usecase.dart';
import 'features/customer/domain/usecases/update_customer_profile_usecase.dart';
import 'features/customer/presentation/bloc/customer_bloc.dart';

// Hotel
import 'features/hotel/data/datasource/hotel_remote_datasource.dart';
import 'features/hotel/data/repositories/hotel_repository_impl.dart';
import 'features/hotel/domain/repositories/hotel_repository.dart';
import 'features/hotel/domain/usecases/create_hotel_profile_usecase.dart';
import 'features/hotel/domain/usecases/get_hotel_profile_usecase.dart';
import 'features/hotel/domain/usecases/update_hotel_profile_usecase.dart';
import 'features/hotel/presentation/bloc/hotel_bloc.dart';

// Food
import 'features/food/data/datasource/food_remote_datasource.dart';
import 'features/food/data/repositories/food_repository_impl.dart';
import 'features/food/domain/repositories/food_repository.dart';
import 'features/food/domain/usecases/add_food_usecase.dart';
import 'features/food/domain/usecases/delete_food_usecase.dart';
import 'features/food/domain/usecases/get_all_foods_usecase.dart';
import 'features/food/domain/usecases/get_hotel_foods_usecase.dart';
import 'features/food/domain/usecases/update_food_usecase.dart';
import 'features/food/presentation/bloc/food_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => SaveUserRoleUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      signupUseCase: sl(),
      getCurrentUserUseCase: sl(),
      saveUserRoleUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<CustomerRemoteDataSource>(
    () => CustomerRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetCustomerProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCustomerProfileUseCase(sl()));

  sl.registerFactory(
    () => CustomerBloc(
      getCustomerProfileUseCase: sl(),
      updateCustomerProfileUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<HotelRemoteDataSource>(
    () => HotelRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<HotelRepository>(
    () => HotelRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => CreateHotelProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetHotelProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateHotelProfileUseCase(sl()));

  sl.registerFactory(
    () => HotelBloc(
      createHotelProfileUseCase: sl(),
      getHotelProfileUseCase: sl(),
      updateHotelProfileUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<FoodRemoteDataSource>(
    () => FoodRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<FoodRepository>(
    () => FoodRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => AddFoodUseCase(sl()));
  sl.registerLazySingleton(() => UpdateFoodUseCase(sl()));
  sl.registerLazySingleton(() => DeleteFoodUseCase(sl()));
  sl.registerLazySingleton(() => GetAllFoodsUseCase(sl()));
  sl.registerLazySingleton(() => GetHotelFoodsUseCase(sl()));

  sl.registerFactory(
    () => FoodBloc(
      addFoodUseCase: sl(),
      updateFoodUseCase: sl(),
      deleteFoodUseCase: sl(),
      getAllFoodsUseCase: sl(),
      getHotelFoodsUseCase: sl(),
    ),
  );
}