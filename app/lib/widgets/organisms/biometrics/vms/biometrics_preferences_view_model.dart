// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import '../../../../constants/key_constants.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../providers/analytics/analytic_events.dart';
import '../../../../providers/analytics/analytics_controller.dart';
import '../../../../services/third_party.dart';

part 'biometrics_preferences_view_model.freezed.dart';
part 'biometrics_preferences_view_model.g.dart';

@freezed
class BiometricsPreferencesViewModelState with _$BiometricsPreferencesViewModelState {
  const factory BiometricsPreferencesViewModelState() = _BiometricsPreferencesViewModelState;

  factory BiometricsPreferencesViewModelState.initialState() => const BiometricsPreferencesViewModelState();
}

@riverpod
class BiometricsPreferencesViewModel extends _$BiometricsPreferencesViewModel with LifecycleMixin {
  @override
  BiometricsPreferencesViewModelState build() {
    return BiometricsPreferencesViewModelState.initialState();
  }

  Future<void> onPermitSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final AppRouter router = ref.read(appRouterProvider);

    logger.d('BiometricsPreferencesViewModel.onPermitSelected');

    final LocalAuthentication localAuthentication = ref.read(localAuthenticationProvider);
    final bool canAuthenticateWithBiometrics = await localAuthentication.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await localAuthentication.isDeviceSupported();

    bool hasAuthenticated = false;
    if (canAuthenticate) {
      try {
        hasAuthenticated = await localAuthentication.authenticate(
          localizedReason: 'Please authenticate to confirm biometric usage.',
          options: const AuthenticationOptions(
            stickyAuth: true,
            useErrorDialogs: true,
          ),
        );
      } catch (e) {
        late final PositiveSnackBar snackBar;
        if (e is PlatformException && e.code == 'NotAvailable') {
          snackBar = PositiveGenericSnackBar(
            title: "Biometrics is not available or permission have not been granted.",
            icon: UniconsLine.envelope_exclamation,
            backgroundColour: colours.black,
          );
        } else {
          snackBar = PositiveGenericSnackBar(
            title: "An unknown error has occurred",
            icon: UniconsLine.envelope_exclamation,
            backgroundColour: colours.black,
          );
        }
        if (router.navigatorKey.currentContext != null) {
          ScaffoldMessenger.of(router.navigatorKey.currentContext!).showSnackBar(snackBar);
        }
      }
    }

    if (!hasAuthenticated) {
      logger.e('BiometricsPreferencesViewModel.onPermitSelected: hasAuthenticated: $hasAuthenticated');
      return;
    }

    await analyticsController.trackEvent(AnalyticEvents.biometricsPreferencesEnabled);
    await sharedPreferences.setBool(kBiometricsAcceptedKey, true);

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
