// Dart imports:
import 'dart:async';

// Package imports:
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/dtos/database/notifications/notification_topic.dart';
import 'package:app/providers/system/handlers/notifications/notification_handler.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:app/constants/profile_constants.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import '../../../../constants/key_constants.dart';
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
  }) = _AccountPreferencesViewModelState;

  factory AccountPreferencesViewModelState.initialState() {
    return const AccountPreferencesViewModelState();
  }
}

@riverpod
class AccountPreferencesViewModel extends _$AccountPreferencesViewModel with LifecycleMixin {
  @override
  AccountPreferencesViewModelState build() {
    return AccountPreferencesViewModelState.initialState();
  }

  @override
  void onFirstRender() {
    unawaited(preload());
    super.onFirstRender();
  }

  Future<void> preload() async {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final bool areBiometricsEnabled = sharedPreferences.getBool(kBiometricsAcceptedKey) ?? false;

    final Set<String> featureFlags = profileController.state.userProfile?.featureFlags ?? {};
    final bool isIncognitoEnabled = featureFlags.any((element) => element == kFeatureFlagIncognito);
    final bool areMarketingEmailsEnabled = featureFlags.any((element) => element == kFeatureFlagMarketing);

    final Set<String> notificationSubscribedTopics = <String>{};
    for (final NotificationTopic preference in NotificationTopic.values) {
      final bool isSubscribed = sharedPreferences.getBool(preference.toSharedPreferencesKey) ?? false;
      if (isSubscribed) {
        notificationSubscribedTopics.add(preference.key);
      }
    }

    state = state.copyWith(
      isIncognitoEnabled: isIncognitoEnabled,
      areBiometricsEnabled: areBiometricsEnabled,
      areMarketingEmailsEnabled: areMarketingEmailsEnabled,
      notificationSubscribedTopics: notificationSubscribedTopics,
    );
  }

  Future<void> onOpenSettingsRequested() async {
    final SystemController systemController = ref.read(systemControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    logger.d('Opening settings');
    await systemController.openSettings();
  }

  Future<void> toggleIncognitoMode() async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final Set<String> currentFlags = profileController.state.userProfile?.featureFlags ?? <String>{};
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

  Future<void> toggleBiometrics() async {
    final Logger logger = ref.read(loggerProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final NotificationsController notificationsController = ref.read(notificationsControllerProvider.notifier);

    final bool isBiometricsEnabled = sharedPreferences.getBool(kBiometricsAcceptedKey) ?? false;
    final bool newValue = !isBiometricsEnabled;
    logger.d('Toggling biometric permissions to $newValue');

    await sharedPreferences.setBool(kBiometricsAcceptedKey, newValue);
    state = state.copyWith(areBiometricsEnabled: newValue);

    late final NotificationPayload payload;

    if (newValue) {
      payload = const NotificationPayload(
        title: 'Thanks!',
        body: 'We have enabled enhanced protection through the use of your biometric data.',
      );
    } else {
      payload = const NotificationPayload(
        title: 'Biometrics Disabled',
        body: 'Your biometric preference was removed successfully.',
      );
    }

    final NotificationHandler handler = notificationsController.getHandlerForPayload(payload);
    await handler.onNotificationDisplayed(payload, true);
  }

  Future<void> toggleMarketingEmails() async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final Set<String> currentFlags = profileController.state.userProfile?.featureFlags ?? <String>{};
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
      final bool newState = !state.notificationSubscribedTopics.contains(topic.key);
      logger.d('Toggling notification topic ${topic.key} to $newState');

      final AccountPreferencesViewModelState expectedNewState = state.copyWith(
        notificationSubscribedTopics: newState ? state.notificationSubscribedTopics.union(<String>{topic.key}) : state.notificationSubscribedTopics.difference(<String>{topic.key}),
        isBusy: true,
      );

      if (newState) {
        await notificationsController.subscribeToTopic(topic.key, topic.toSharedPreferencesKey);
      } else {
        await notificationsController.unsubscribeFromTopic(topic.key, topic.toSharedPreferencesKey);
      }

      state = expectedNewState;
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
