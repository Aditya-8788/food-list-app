// TODO: Implement auth BLoC.
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
// import '../../domain/usecases/google_login_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/save_user_role_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SaveUserRoleUseCase saveUserRoleUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.getCurrentUserUseCase,
    required this.saveUserRoleUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignupRequested>(_onSignupRequested);
    on<AuthSaveRoleRequested>(_onSaveRoleRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await getCurrentUserUseCase();

      if (user == null) {
        emit(AuthUnauthenticated());
      } else if (user.role.isEmpty) {
        emit(AuthRoleRequired(user));
      } else {
        emit(AuthAuthenticated(user));
      }
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await loginUseCase(
        email: event.email,
        password: event.password,
      );

      _handleUserRole(user, emit);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignupRequested(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await signupUseCase(
        name: event.name,
        email: event.email,
        password: event.password,
        phone: event.phone,
        role: event.role,
      );

      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Future<void> _onGoogleLoginRequested(
  //   AuthGoogleLoginRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
   // emit(AuthLoading());

   // try {
     // final user = await googleLoginUseCase();

     // _handleUserRole(user, emit);
    

  Future<void> _onSaveRoleRequested(
    AuthSaveRoleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await saveUserRoleUseCase(
        uid: event.uid,
        role: event.role,
      );

      final user = await getCurrentUserUseCase();

      if (user == null) {
        emit(AuthUnauthenticated());
      } else {
        emit(AuthAuthenticated(user));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await logoutUseCase();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _handleUserRole(UserEntity user, Emitter<AuthState> emit) {
    if (user.role.isEmpty) {
      emit(AuthRoleRequired(user));
    } else {
      emit(AuthAuthenticated(user));
    }
  }
}