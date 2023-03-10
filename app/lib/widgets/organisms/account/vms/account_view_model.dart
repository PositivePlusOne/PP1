// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import '../../../../hooks/lifecycle_hook.dart';

part 'account_view_model.freezed.dart';
part 'account_view_model.g.dart';

@freezed
class AccountViewModelState with _$AccountViewModelState {
  const factory AccountViewModelState() = _AccountViewModelState;

  factory AccountViewModelState.initialState() => const AccountViewModelState();
}

@riverpod
class AccountViewModel extends _$AccountViewModel with LifecycleMixin {
  @override
  AccountViewModelState build() {
    return AccountViewModelState.initialState();
  }
}
