import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tropical_iptv_ios/repository/api/api.dart';
import 'package:tropical_iptv_ios/repository/locale/locale.dart';
import 'package:tropical_iptv_ios/repository/models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthApi _authApi = AuthApi();

  AuthBloc() : super(AuthInitial()) {
    on<AuthRegister>(_onAuthRegister);
    on<AuthLogout>(_onAuthLogout);
    on<AuthCheck>(_onAuthCheck);
  }

  Future<void> _onAuthRegister(
    AuthRegister event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await _authApi.registerUser(
        event.username,
        event.password,
        event.url,
      );

      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailed('Login failed. Please check your credentials.'));
      }
    } catch (e) {
      emit(AuthFailed('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onAuthLogout(
    AuthLogout event,
    Emitter<AuthState> emit,
  ) async {
    await LocaleApi.deleteUser();
    emit(AuthLoggedOut());
  }

  Future<void> _onAuthCheck(
    AuthCheck event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await LocaleApi.getUser();

      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }
}
