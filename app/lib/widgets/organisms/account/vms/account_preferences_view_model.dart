// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicons/unicons.dart';
import 'package:universal_platform/universal_platform.dart';

// Project imports:
import 'package:app/constants/application_constants.dart';
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/database/notifications/notification_topic.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/main.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/organisms/biometrics/vms/biometrics_preferences_view_model.dart';
import '../../../../services/third_party.dart';

part 'account_preferences_view_model.freezed.dart';
part 'account_preferences_view_model.g.dart';

@freezed
class AccountPreferencesViewModelState with _$AccountPreferencesViewModelState {
  const factory AccountPreferencesViewModelState({
    @Default(false) bool isBusy,
    @Default({}) Set<String> notificationSubscribedTopics,
    @Default(false) bool isIncognitoEnabled,
    @Default(false) bool areBiometricsEnabled,
    @Default(false) bool areMarketingEmailsEnabled,
    @Default(AvailableBiometrics.none) AvailableBiometrics availableBiometrics,
  }) = _AccountPreferencesViewModelState;

  factory AccountPreferencesViewModelState.initialState() {
    return const AccountPreferencesViewModelState();
  }
}

@riverpod
class AccountPreferencesViewModel extends _$AccountPreferencesViewModel with LifecycleMixin {
  late final bool isIOS;

  @override
  AccountPreferencesViewModelState build() {
    return AccountPreferencesViewModelState.initialState();
  }

  @override
  void onFirstRender() {
    unawaited(preload());
    checkBiometrics();
    updateOS();
    super.onFirstRender();
  }

  Future<void> preload() async {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final bool areBiometricsEnabled = sharedPreferences.getBool(kBiometricsAcceptedKey) ?? false;

    final Set<String> featureFlags = profileController.state.currentProfile?.featureFlags ?? {};
    final bool isIncognitoEnabled = featureFlags.any((element) => element == kFeatureFlagIncognito);
    final bool areMarketingEmailsEnabled = featureFlags.any((element) => element == kFeatureFlagMarketing);

    final Set<String> notificationSubscribedTopics = <String>{};
    for (final NotificationTopic preference in NotificationTopic.allTopics) {
      final bool isSubscribed = sharedPreferences.getBool(preference.toSharedPreferencesKey) ?? false;
      if (isSubscribed) {
        notificationSubscribedTopics.add(NotificationTopic.toJson(preference));
      }
    }

    state = state.copyWith(
      isIncognitoEnabled: isIncognitoEnabled,
      areBiometricsEnabled: areBiometricsEnabled,
      areMarketingEmailsEnabled: areMarketingEmailsEnabled,
      notificationSubscribedTopics: notificationSubscribedTopics,
    );
  }

  IconData get biometricToggleIcon {
    switch (state.availableBiometrics) {
      case AvailableBiometrics.face:
        if (isIOS) {
          return UniconsLine.smile;
        } else {
          return UniconsLine.eye;
        }
      case AvailableBiometrics.iris:
      case AvailableBiometrics.strong:
      case AvailableBiometrics.weak:
        return UniconsLine.eye;
      case AvailableBiometrics.none:
        return UniconsLine.asterisk;
      default:
        return UniconsLine.crosshair;
    }
  }

  Future<void> checkBiometrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

    AvailableBiometrics availableBiometricsEnum = AvailableBiometrics.none;

    if (availableBiometrics.contains(BiometricType.weak)) {
      availableBiometricsEnum = AvailableBiometrics.weak;
    }
    if (availableBiometrics.contains(BiometricType.strong) || availableBiometrics.contains(BiometricType.fingerprint)) {
      availableBiometricsEnum = AvailableBiometrics.strong;
    }
    if (availableBiometrics.contains(BiometricType.iris)) {
      availableBiometricsEnum = AvailableBiometrics.iris;
    }
    if (availableBiometrics.contains(BiometricType.face)) {
      availableBiometricsEnum = AvailableBiometrics.face;
    }
    state = state.copyWith(availableBiometrics: availableBiometricsEnum);
  }

  Future<void> onBiometricsToggle() async {
    final AsyncValue<SharedPreferences> sharedPreferencesAsync = providerContainer.read(sharedPreferencesProvider);
    final SharedPreferences sharedPreferences = sharedPreferencesAsync.value!;
    final bool biometricPreferencesSet = sharedPreferences.getBool(kBiometricsAcceptedKey) == true;
    state = state.copyWith(isBusy: true);

    try {
      if (biometricPreferencesSet) {
        await onBiometricsChange(false);
      } else {
        await onBiometricsChange(true);
      }
    } finally {
      sharedPreferences.reload();
      state = state.copyWith(
        areBiometricsEnabled: sharedPreferences.getBool(kBiometricsAcceptedKey) ?? false,
        isBusy: false,
      );
    }
  }

  void updateOS() {
    if (UniversalPlatform.isIOS) {
      isIOS = true;
    } else {
      isIOS = false;
    }
  }

  Future<void> onBiometricsChange(bool enableBiometrics) async {
    final Logger logger = ref.read(loggerProvider);
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
        await sharedPreferences.setInt(kBiometricsAcceptedLastTime, DateTime.now().millisecondsSinceEpoch);
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
            title: "Biometrics is not available or permission has not been granted.",
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
    await sharedPreferences.setBool(kBiometricsAcceptedKey, enableBiometrics);
  }

  Future<void> onOpenSettingsRequested() async {
    final SystemController systemController = ref.read(systemControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    logger.d('Opening settings');
    await systemController.openSettings();
  }

  Future<void> toggleIncognitoMode(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final Set<String> currentFlags = profileController.state.currentProfile?.featureFlags ?? <String>{};
    final Set<String> newFlags = <String>{
      ...currentFlags.where((element) => element != kFeatureFlagIncognito),
      if (!state.isIncognitoEnabled) kFeatureFlagIncognito,
    };

    final bool isIncognitoEnabled = newFlags.any((element) => element == kFeatureFlagIncognito);

    try {
      logger.d('Updating feature flags to $newFlags');
      state = state.copyWith(isBusy: true);
      await profileController.updateFeatureFlags(newFlags);
      state = state.copyWith(isIncognitoEnabled: isIncognitoEnabled);
    } finally {
      state = state.copyWith(isBusy: false);
    }

    state = state.copyWith(isIncognitoEnabled: isIncognitoEnabled);
  }

  Future<void> toggleBiometrics(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final DesignColorsModel colours = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final BiometricsPreferencesViewModel biometricsViewModel = ref.watch(biometricsPreferencesViewModelProvider.notifier);

    final bool isBiometricsEnabled = sharedPreferences.getBool(kBiometricsAcceptedKey) ?? false;
    final bool newValue = !isBiometricsEnabled;
    final localizations = AppLocalizations.of(context)!;
    logger.d('Toggling biometric permissions to $newValue');

    if (newValue) {
      // we are turning on, do we have biometrics?
      final availableBiometrics = await LocalAuthentication().getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        // there are none
        ScaffoldMessenger.of(context).showSnackBar(PositiveErrorSnackBar(
          text: localizations.page_profile_biometrics_none_available,
        ));
        // and don't change the setting
        return;
      }
    }

    await sharedPreferences.setBool(kBiometricsAcceptedKey, newValue);
    state = state.copyWith(areBiometricsEnabled: newValue);

    // inform nicely what was just done
    if (newValue) {
      // be sure that we are authenticated
      await biometricsViewModel.onPermitSelected();

      // and show them that we now are happy
      ScaffoldMessenger.of(context).showSnackBar(
        PositiveGenericSnackBar(title: localizations.page_profile_biometrics_success_body, icon: Icons.fingerprint, backgroundColour: colours.black),
      );
    } else {
      // and let them know that's disabled
      ScaffoldMessenger.of(context).showSnackBar(
        PositiveGenericSnackBar(title: localizations.page_profile_biometrics_disabled_body, icon: Icons.fingerprint, backgroundColour: colours.black),
      );
    }
  }

  Future<void> toggleMarketingEmails(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final Set<String> currentFlags = profileController.state.currentProfile?.featureFlags ?? <String>{};
    final Set<String> newFlags = <String>{
      ...currentFlags.where((element) => element != kFeatureFlagMarketing),
      if (!state.areMarketingEmailsEnabled) kFeatureFlagMarketing,
    };

    final bool areMarketingEmailsEnabled = newFlags.any((element) => element == kFeatureFlagMarketing);

    try {
      logger.d('Updating feature flags to $newFlags');
      state = state.copyWith(isBusy: true);

      await profileController.updateFeatureFlags(newFlags);
      state = state.copyWith(areMarketingEmailsEnabled: areMarketingEmailsEnabled);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> toggleNotificationTopic(NotificationTopic topic) async {
    final Logger logger = ref.read(loggerProvider);
    final NotificationsController notificationsController = ref.read(notificationsControllerProvider.notifier);

    state = state.copyWith(isBusy: true);

    try {
      final String key = NotificationTopic.toJson(topic);
      final bool newState = !state.notificationSubscribedTopics.contains(key);
      logger.d('Toggling notification topic $key to $newState');

      if (newState && !(await Permission.notification.isGranted)) {
        // we just selected to enable some kind of notification but the permissions are not valid
        ref.read(notificationPermissionsProvider.future);
      }

      final AccountPreferencesViewModelState expectedNewState = state.copyWith(
        notificationSubscribedTopics: newState ? state.notificationSubscribedTopics.union(<String>{key}) : state.notificationSubscribedTopics.difference(<String>{key}),
        isBusy: true,
      );

      if (newState) {
        await notificationsController.subscribeToTopic(key, topic.toSharedPreferencesKey);
      } else {
        await notificationsController.unsubscribeFromTopic(key, topic.toSharedPreferencesKey);
      }

      state = expectedNewState;
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}

enum AvailableBiometrics {
  none,
  weak,
  strong,
  iris,
  face,
}
