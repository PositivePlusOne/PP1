// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../services/third_party.dart';

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

  Future<void> onBackButtonPressed() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d('onBackButtonPressed');
    appRouter.removeLast();
  }

  Future<void> onEditAccountButtonPressed() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    throw UnimplementedError();
    // logger.d('onEditAccountButtonPressed');
    // appRouter.push(const EditAccountRoute());
  }
}
