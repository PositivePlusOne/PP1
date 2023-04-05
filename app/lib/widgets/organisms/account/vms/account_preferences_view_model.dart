// Dart imports:
import 'dart:async';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:app/enumerations/positive_notification_topic.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/providers/user/profile_controller.dart';
import '../../../../constants/key_constants.dart';
import '../../../../enumerations/positive_feature_flag.dart';
import '../../../../providers/system/models/positive_notification_model.dart';
import '../../../../services/third_party.dart';

part 'account_preferences_view_model.freezed.dart';
part 'account_preferences_view_model.g.dart';

@freezed
class AccountPreferencesViewModelState with _$AccountPreferencesViewModelState {
  const factory AccountPreferencesViewModelState({
    @Default(false) bool isBusy,
    @Default(false) bool isIncognitoModeEnabled,
    @Default(false) bool isBiometricsEnabled,
    @Default(false) bool areMarketingEmailsEnabled,
    @Default({}) Set<String> notificationSubscribedTopics,
  }) = _AccountPreferencesViewModelState;

  factory AccountPreferencesViewModelState.initialState() => const AccountPreferencesViewModelState();
}

@riverpod
class AccountPreferencesViewModel extends _$AccountPreferencesViewModel with LifecycleMixin {
  Set<PositiveFeatureFlag> get featureFlags {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final Set<PositiveFeatureFlag> results = <PositiveFeatureFlag>{};
    for (final String flag in profileController.state.userProfile?.featureFlags ?? {}) {
      final PositiveFeatureFlag? featureFlag = PositiveFeatureFlag.fromString(flag);
      if (featureFlag != null) {
        results.add(featureFlag);
      }
    }

    return results;
  }

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
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final bool isBiometricsEnabled = sharedPreferences.getBool(kBiometricsAcceptedKey) ?? false;

    final bool isIncognitoModeEnabled = featureFlags.any((element) => element.name == PositiveFeatureFlag.incognitoMode.name);
    final bool areMarketingEmailsEnabled = featureFlags.any((element) => element.name == PositiveFeatureFlag.marketingEmails.name);

    final Set<String> notificationSubscribedTopics = <String>{};
    for (final PositiveNotificationTopic preference in PositiveNotificationTopic.values) {
      final bool isSubscribed = sharedPreferences.getBool(preference.toSharedPreferencesKey) ?? false;
      if (isSubscribed) {
        notificationSubscribedTopics.add(preference.key);
      }
    }

    state = state.copyWith(
      isIncognitoModeEnabled: isIncognitoModeEnabled,
      isBiometricsEnabled: isBiometricsEnabled,
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

    final bool newState = !state.isIncognitoModeEnabled;
    logger.d('Toggling incognito mode to $newState');
    state = state.copyWith(isIncognitoModeEnabled: newState);

    final Set<String> currentFlags = profileController.state.userProfile?.featureFlags ?? <String>{};
    final Set<String> newFlags = <String>{};
    if (newState) {
      newFlags.addAll(currentFlags);
      newFlags.add(PositiveFeatureFlag.incognitoMode.name);
    } else {
      newFlags.addAll(currentFlags.where((element) => element != PositiveFeatureFlag.incognitoMode.name));
    }

    try {
      logger.d('Updating feature flags to $newFlags');
      state = state.copyWith(isBusy: true);
      await profileController.updateFeatureFlags(newFlags);
      state = state.copyWith(isIncognitoModeEnabled: newState);
    } finally {
      state = state.copyWith(isBusy: false);
    }

    state = state.copyWith(isIncognitoModeEnabled: newState);
  }

  Future<void> toggleBiometrics() async {
    final Logger logger = ref.read(loggerProvider);
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final NotificationsController notificationsController = ref.read(notificationsControllerProvider.notifier);

    final bool isBiometricsEnabled = sharedPreferences.getBool(kBiometricsAcceptedKey) ?? false;
    final bool newValue = !isBiometricsEnabled;
    logger.d('Toggling biometric permissions to $newValue');

    await sharedPreferences.setBool(kBiometricsAcceptedKey, newValue);
    state = state.copyWith(isBiometricsEnabled: newValue);

    if (newValue) {
      await notificationsController.displayForegroundNotification(PositiveNotificationModel(
        title: 'Thanks!',
        body: 'We have enabled enhanced protection through the use of your biometric data.',
        topic: PositiveNotificationTopic.other.key,
      ));
    } else {
      await notificationsController.displayForegroundNotification(PositiveNotificationModel(
        title: 'Biometrics Disabled',
        body: 'Your biometric preference was removed successfully.',
        topic: PositiveNotificationTopic.other.key,
      ));
    }
  }

  Future<void> toggleMarketingEmails() async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    final bool newState = !state.areMarketingEmailsEnabled;
    logger.d('Toggling marketing emails to $newState');
    state = state.copyWith(areMarketingEmailsEnabled: newState, isBusy: true);

    final Set<String> currentFlags = profileController.state.userProfile?.featureFlags ?? <String>{};
    final Set<String> newFlags = <String>{};
    if (newState) {
      newFlags.addAll(currentFlags);
      newFlags.add(PositiveFeatureFlag.marketingEmails.name);
    } else {
      newFlags.addAll(currentFlags.where((element) => element != PositiveFeatureFlag.marketingEmails.name));
    }

    try {
      await profileController.updateFeatureFlags(newFlags);
      state = state.copyWith(areMarketingEmailsEnabled: newState);
    } catch (ex) {
      logger.e('Failed to update feature flags', ex);
      state = state.copyWith(areMarketingEmailsEnabled: !newState);
      rethrow;
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> toggleNotificationTopic(PositiveNotificationTopic topic) async {
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
