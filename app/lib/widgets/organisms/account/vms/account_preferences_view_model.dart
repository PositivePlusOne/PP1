// Package imports:
import 'package:app/providers/system/system_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:app/enumerations/positive_notification_preference.dart';
import 'package:app/providers/system/notifications_controller.dart';
import '../../../../constants/key_constants.dart';
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
    @Default(false) bool isMarketingEmailsEnabled,
  }) = _AccountPreferencesViewModelState;

  factory AccountPreferencesViewModelState.initialState() => const AccountPreferencesViewModelState();
}

@riverpod
class AccountPreferencesViewModel extends _$AccountPreferencesViewModel {
  @override
  AccountPreferencesViewModelState build() {
    return AccountPreferencesViewModelState.initialState();
  }

  Future<void> onOpenSettingsRequested() async {
    final SystemController systemController = ref.read(systemControllerProvider.notifier);
    final Logger logger = ref.read(loggerProvider);

    logger.d('Opening settings');
    await systemController.openSettings();
  }

  Future<void> toggleIncognitoMode() async {
    state = state.copyWith(isIncognitoModeEnabled: !state.isIncognitoModeEnabled);
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
        topic: PositiveNotificationPreference.other.topicKey,
      ));
    } else {
      await notificationsController.displayForegroundNotification(PositiveNotificationModel(
        title: 'Biometrics Disabled',
        body: 'Your biometric preference was removed successfully.',
        topic: PositiveNotificationPreference.other.topicKey,
      ));
    }
  }

  Future<void> toggleMarketingEmails() async {
    state = state.copyWith(isMarketingEmailsEnabled: !state.isMarketingEmailsEnabled);
  }
}
