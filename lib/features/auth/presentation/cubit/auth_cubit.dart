import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_over_app/features/auth/data/models/user_model.dart';
import 'package:video_over_app/features/auth/data/repositories/auth_repository.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  final String token;
  AuthAuthenticated(this.user, this.token);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final token = await _authRepository.getToken();
    final user = await _authRepository.getUser();

    if (token != null && user != null) {
      emit(AuthAuthenticated(user, token));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.signInWithGoogle();
      if (response != null) {
        emit(AuthAuthenticated(response.user, response.token));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    await _authRepository.signOut();
    emit(AuthUnauthenticated());
  }
}
