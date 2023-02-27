// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import '../../../../hooks/lifecycle_hook.dart';

part 'onboarding_connect_view_model.freezed.dart';
part 'onboarding_connect_view_model.g.dart';

@freezed
class OnboardingConnectViewModelState with _$OnboardingConnectViewModelState {
  const factory OnboardingConnectViewModelState() = _OnboardingConnectViewModelState;

  factory OnboardingConnectViewModelState.initialState() => const OnboardingConnectViewModelState();
}

@riverpod
class OnboardingConnectViewModel extends _$OnboardingConnectViewModel with LifecycleMixin {
  @override
  OnboardingConnectViewModelState build() {
    return OnboardingConnectViewModelState.initialState();
  }

  Future<void> onContinueSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    await appRouter.push(OnboardingEducationRoute());
  }

  Future<void> onSkipSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    await appRouter.push(OnboardingOurPledgeRoute());
  }
}
