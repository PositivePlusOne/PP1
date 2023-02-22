// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/key_constants.dart';
import '../../../hooks/lifecycle_hook.dart';
import '../../../services/third_party.dart';
import '../../analytics/analytic_events.dart';
import '../../analytics/analytics_controller.dart';

part 'biometrics_preferences_controller.freezed.dart';
part 'biometrics_preferences_controller.g.dart';

@freezed
class BiometricsPreferencesControllerState with _$BiometricsPreferencesControllerState {
  const factory BiometricsPreferencesControllerState() = _BiometricsPreferencesControllerState;

  factory BiometricsPreferencesControllerState.initialState() => const BiometricsPreferencesControllerState();
}

@riverpod
class BiometricsPreferencesController extends _$BiometricsPreferencesController with LifecycleMixin {
  @override
  BiometricsPreferencesControllerState build() {
    return BiometricsPreferencesControllerState.initialState();
  }

  Future<void> onPermitSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);

    await analyticsController.trackEvent(AnalyticEvents.biometricsPreferencesEnabled);
    await sharedPreferences.setBool(kBiometricsAcceptedKey, true);

    // Request first permissions so that the dialog is shown
    await ref.read(notificationPermissionsProvider.future);

    appRouter.removeWhere((route) => true);
    appRouter.push(const HomeRoute());
  }

  Future<void> onDenySelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);

    await analyticsController.trackEvent(AnalyticEvents.biometricsPreferencesDisabled);
    await sharedPreferences.setBool(kBiometricsAcceptedKey, false);

    appRouter.removeWhere((route) => true);
    await appRouter.push(const HomeRoute());
  }
}
