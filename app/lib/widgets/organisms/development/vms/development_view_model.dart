// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/providers/location/location_controller.dart';
import 'package:app/services/api.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../services/third_party.dart';

part 'development_view_model.freezed.dart';
part 'development_view_model.g.dart';

@freezed
class DevelopmentViewModelState with _$DevelopmentViewModelState {
  const factory DevelopmentViewModelState({
    @Default(false) bool displaySelectablePostIDs,
    @Default(false) bool darkMode,
    @Default('Pending...') String status,
  }) = _DevelopmentViewModelState;

  factory DevelopmentViewModelState.initialState() => const DevelopmentViewModelState();
}

@Riverpod(keepAlive: true)
class DevelopmentViewModel extends _$DevelopmentViewModel with LifecycleMixin {
  @override
  DevelopmentViewModelState build() {
    return DevelopmentViewModelState.initialState();
  }

  Future<void> restartApp() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('Restarting app');
    appRouter.removeWhere((route) => true);
    await appRouter.push(SplashRoute());
  }

  Future<void> toggleSelectablePostIDs() async {
    final Logger logger = ref.read(loggerProvider);

    logger.d('Toggling selectable post IDs');
    state = state.copyWith(status: 'Toggling selectable IDs to ${!state.displaySelectablePostIDs}');
    state = state.copyWith(displaySelectablePostIDs: !state.displaySelectablePostIDs);
  }

  Future<void> toggleDarkMode() async {
    final Logger logger = ref.read(loggerProvider);

    logger.d('Toggling dark mode');
    state = state.copyWith(status: 'Toggling dark mode to ${!state.darkMode}');
    state = state.copyWith(darkMode: !state.darkMode);
  }

  Future<void> displayAuthClaims() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    logger.d('Displaying auth claims');

    state = state.copyWith(status: 'Displaying auth claims');

    try {
      final Map<String, dynamic> claims = (await firebaseAuth.currentUser?.getIdTokenResult())?.claims ?? {};
      logger.d('Auth claims: $claims');
      state = state.copyWith(status: 'Auth claims: $claims');
    } catch (ex) {
      logger.e('Failed to display auth claims. $ex');
      state = state.copyWith(status: 'Failed to display auth claims');
    }
  }

  Future<void> displayNotificationSettings() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseMessaging firebaseMessaging = ref.read(firebaseMessagingProvider);
    logger.d('Displaying notification settings');

    state = state.copyWith(status: 'Displaying notification settings');
    try {
      final NotificationSettings settings = await firebaseMessaging.getNotificationSettings();
      final Map<String, dynamic> settingsMap = {
        'alert': settings.alert,
        'announcement': settings.announcement,
        'authorizationStatus': settings.authorizationStatus,
        'badge': settings.badge,
        'carPlay': settings.carPlay,
        'lockScreen': settings.lockScreen,
        'notificationCenter': settings.notificationCenter,
        'showPreviews': settings.showPreviews,
        'timeSensitive': settings.timeSensitive,
        'criticalAlert': settings.criticalAlert,
        'sound': settings.sound,
      };

      logger.d('Notification settings: $settingsMap');
      state = state.copyWith(status: 'Notification settings: $settingsMap');
    } catch (ex) {
      logger.e('Failed to display notification settings. $ex');
      state = state.copyWith(status: 'Failed to display notification settings');
    }
  }

  Future<void> sendTestNotification() async {
    final Logger logger = ref.read(loggerProvider);
    final SystemApiService systemApiService = await ref.read(systemApiServiceProvider.future);
    logger.d('Sending test notification');

    state = state.copyWith(status: 'Sending test notification');

    try {
      await systemApiService.sendTestNotification();
      logger.d('Successfully sent test notification');
      state = state.copyWith(status: 'Successfully sent test notification');
    } catch (ex) {
      logger.e('Failed to send test notification. $ex');
      state = state.copyWith(status: 'Failed to send test notification');
    }
  }

  Future<void> requestManualLocation() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final BuildContext context = appRouter.navigatorKey.currentContext!;
    final LocationController locationController = ref.read(locationControllerProvider.notifier);

    logger.d('Requesting manual location');
    state = state.copyWith(status: 'Requesting manual location');

    try {
      final LatLng? result = await showDialog(
          context: context,
          builder: (context) {
            final TextEditingController latitudeController = TextEditingController();
            final TextEditingController longitudeController = TextEditingController();

            return AlertDialog(
              title: const Text('Enter manual location'),
              content: Column(
                children: <Widget>[
                  TextFormField(
                    controller: latitudeController,
                    decoration: const InputDecoration(labelText: 'Latitude'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: longitudeController,
                    decoration: const InputDecoration(labelText: 'Longitude'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final double? latitude = double.tryParse(latitudeController.text);
                    final double? longitude = double.tryParse(longitudeController.text);
                    if (latitude != null && longitude != null) {
                      state = state.copyWith(status: 'Manual location: $latitude, $longitude');
                    } else {
                      state = state.copyWith(status: 'Invalid manual location');
                    }

                    LatLng? result;
                    if (latitude != null && longitude != null) {
                      result = LatLng(latitude, longitude);
                    }

                    Navigator.of(context).pop(result);
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          });

      if (result != null) {
        locationController.setManualGPSLocation(result.latitude, result.longitude);
      } else {
        state = state.copyWith(status: 'Cancelled manual location');
      }
    } catch (ex) {
      logger.e('Failed to request manual location. $ex');
      state = state.copyWith(status: 'Failed to request manual location');
    }
  }
}
