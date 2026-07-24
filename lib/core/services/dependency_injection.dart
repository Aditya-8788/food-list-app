import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasource/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/save_user_role_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import '../services/firebase_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Firebase

  sl.registerLazySingleton(
    () => FirebaseService.auth,
  );

  sl.registerLazySingleton(
    () => FirebaseService.firestore,
  );
//   sl.registerLazySingleton(
//   () => GoogleSignIn(),
// );
  // DataSource

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );

  // Repository

  sl.registerLazySingleton(
    () => AuthRepositoryImpl(sl()),
  );

  // UseCases

  sl.registerLazySingleton(
    () => LoginUseCase(sl()),
  );

  sl.registerLazySingleton(
    () => SignupUseCase(sl()),
  );

  sl.registerLazySingleton(
    () => LogoutUseCase(sl()),
  );

  sl.registerLazySingleton(
    () => GetCurrentUserUseCase(sl()),
  );

  sl.registerLazySingleton(
    () => SaveUserRoleUseCase(sl()),
  );

  // Bloc

  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      signupUseCase: sl(),
      getCurrentUserUseCase: sl(),
      saveUserRoleUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );
}