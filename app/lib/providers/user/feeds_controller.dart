// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:synchronized/synchronized.dart';

// Project imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import '../../services/third_party.dart';

// Project imports:

part 'feeds_controller.freezed.dart';
part 'feeds_controller.g.dart';

@freezed
class FeedsControllerState with _$FeedsControllerState {
  const factory FeedsControllerState({
    @Default(false) bool isBusy,
  }) = _FeedsControllerState;

  factory FeedsControllerState.initialState() => const FeedsControllerState();
}

@Riverpod(keepAlive: true)
class FeedsController extends _$FeedsController {
  final Lock connectionMutex = Lock();

  StreamSubscription<fba.User?>? userSubscription;
  StreamSubscription<Profile?>? userProfileSubscription;
  StreamSubscription<String>? firebaseTokenSubscription;

  StreamFeedClient? _streamFeedClient;

  @override
  FeedsControllerState build() {
    return FeedsControllerState.initialState();
  }

  Future<void> setupListeners() async {
    final FirebaseMessaging firebaseMessaging = ref.read(firebaseMessagingProvider);

    await userSubscription?.cancel();
    userSubscription = ref.read(userControllerProvider.notifier).userChangedController.stream.listen(onUserChanged);

    await userProfileSubscription?.cancel();
    userProfileSubscription = ref.read(profileControllerProvider.notifier).userProfileStreamController.stream.listen(onUserProfileChanged);

    await firebaseTokenSubscription?.cancel();
    firebaseTokenSubscription = firebaseMessaging.onTokenRefresh.listen((String token) async {
      await updateStreamDevices(token);
    });
  }

  Future<void> onUserChanged(fba.User? user) async {
    final log = ref.read(loggerProvider);

    await disconnectStreamUser();

    if (user == null) {
      log.i('[FeedsController] onUserChanged() user is null');
      return;
    }

    await connectStreamUser();
  }

  Future<void> onUserProfileChanged(Profile? event) async {
    final log = ref.read(loggerProvider);
    log.d('[FeedsController] onUserProfileChanged()');

    if (event == null) {
      log.e('[FeedsController] onUserProfileChanged() event is null');
      return;
    }

    unawaited(attemptToUpdateStreamProfile());
  }

  Future<void> attemptToUpdateStreamProfile() async {
    final log = ref.read(loggerProvider);
    log.d('[FeedsController] attemptToUpdateStreamProfile()');
  }

  Future<void> disconnectStreamUser() => connectionMutex.synchronized(() async {
        final log = ref.read(loggerProvider);
        log.i('[FeedsController] disconnectStreamUser()');
      });

  Future<void> connectStreamUser({
    bool updateDevices = true,
  }) async =>
      connectionMutex.synchronized(() async {
        final log = ref.read(loggerProvider);
        log.i('[FeedsController] connectStreamUser()');
      });

  Future<void> updateStreamDevices(String fcmToken) async {}
}
