import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_blog_app/core/common/cubit/app_user_cubit.dart';
import 'package:new_blog_app/core/common/entities/user.dart';
import 'package:new_blog_app/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:new_blog_app/features/auth/domain/usecases/user_sign_in_usecase.dart';
import 'package:new_blog_app/features/auth/domain/usecases/user_sign_up_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUpUsecase _signUpUsecase;
  final UserSignInUsecase _signInUsecase;
  final CurrentUserUseCase _currentUserUseCase;
  final AppUserCubit _appUserCubit;
  AuthBloc(
    this._signUpUsecase,
    this._signInUsecase,
    this._currentUserUseCase,
    this._appUserCubit,
  ) : super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<UserSignUp>(_onAuthSignUp);
    on<UserSignIn>(_onAuthSignIn);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _currentUserUseCase(NoParams());
    response.fold(
      (l) => emit(AuthFailureCheck(message: l.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignUp(UserSignUp event, Emitter<AuthState> emit) async {
    // emit(AuthLoading());
    final response = await _signUpUsecase.call(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    response.fold(
      (l) => emit(AuthFailure(message: l.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignIn(UserSignIn event, Emitter<AuthState> emit) async {
    // emit(AuthLoading());
    final res = await _signInUsecase(
      UserSignInParams(email: event.email, password: event.password),
    );
    res.fold(
      (l) => emit(AuthFailure(message: l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSucces(user: user));
  }
}
