// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_view_model.freezed.dart';
part 'login_view_model.g.dart';

@freezed
class LoginViewModelState with _$LoginViewModelState {
  const factory LoginViewModelState() = _LoginViewModelState;

  factory LoginViewModelState.initialState() => const LoginViewModelState();
}

@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  LoginViewModelState build() {
    return LoginViewModelState.initialState();
  }
}
