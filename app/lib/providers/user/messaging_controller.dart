// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:synchronized/synchronized.dart';

// Project imports:
import 'package:app/dtos/database/user/user_profile.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import '../../services/third_party.dart';

// Project imports:

part 'messaging_controller.freezed.dart';
part 'messaging_controller.g.dart';

@freezed
class MessagingControllerState with _$MessagingControllerState {
  const factory MessagingControllerState({
    @Default(false) bool isBusy,
  }) = _MessagingControllerState;

  factory MessagingControllerState.initialState() => const MessagingControllerState();
}

@Riverpod(keepAlive: true)
class MessagingController extends _$MessagingController {
  final Lock connectionMutex = Lock();

  StreamSubscription<fba.User?>? userSubscription;
  StreamSubscription<UserProfile?>? profileSubscription;
  StreamSubscription<String>? firebaseTokenSubscription;

  String get pushProviderName {
    switch (ref.read(systemControllerProvider).environment) {
      case SystemEnvironment.develop:
        return 'Development';
      case SystemEnvironment.staging:
        return 'Staging';
      case SystemEnvironment.production:
        return 'Production';
    }
  }

  @override
  MessagingControllerState build() {
    return MessagingControllerState.initialState();
  }

  Future<void> setupListeners() async {
    final FirebaseMessaging firebaseMessaging = ref.read(firebaseMessagingProvider);

    await userSubscription?.cancel();
    userSubscription = ref.read(userControllerProvider.notifier).userChangedController.stream.listen(onUserChanged);

    await profileSubscription?.cancel();
    profileSubscription = ref.read(profileControllerProvider.notifier).userProfileStreamController.stream.listen(onUserProfileChanged);

    await firebaseTokenSubscription?.cancel();
    firebaseTokenSubscription = firebaseMessaging.onTokenRefresh.listen((String token) async {
      await updateStreamDevices(token);
    });
  }

  Future<void> onUserChanged(fba.User? user) async {
    final log = ref.read(loggerProvider);

    await disconnectStreamUser();

    if (user == null) {
      log.i('[MessagingController] onUserChanged() user is null');
      return;
    }

    await connectStreamUser();
  }

  Future<void> onUserProfileChanged(UserProfile? event) async {
    final log = ref.read(loggerProvider);
    log.d('[MessagingController] onUserProfileChanged()');

    if (event == null) {
      log.e('[MessagingController] onUserProfileChanged() event is null');
      return;
    }

    unawaited(attemptToUpdateStreamProfile());
  }

  Future<void> attemptToUpdateStreamProfile() async {
    final log = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    log.d('[MessagingController] attemptToUpdateStreamProfile()');

    if (streamChatClient.state.currentUser == null) {
      log.e('[MessagingController] attemptToUpdateStreamProfile() user is null');
      return;
    }

    final Map<String, Object?> currentData = streamChatClient.state.currentUser!.extraData;
    final Map<String, Object?> newData = buildUserExtraData();

    // Deep equality check
    if (const DeepCollectionEquality().equals(currentData, newData)) {
      log.i('[MessagingController] attemptToUpdateStreamProfile() no changes');
      return;
    }

    final User streamUserRequest = buildMessagingUser(id: streamChatClient.state.currentUser!.id);
    await streamChatClient.updateUser(streamUserRequest);
    log.i('[MessagingController] attemptToUpdateStreamProfile() updated user');
  }

  Future<void> disconnectStreamUser() => connectionMutex.synchronized(() async {
        final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
        final log = ref.read(loggerProvider);

        if (streamChatClient.wsConnectionStatus == ConnectionStatus.disconnected) {
          log.e('[MessagingController] disconnectStreamUser() not connected');
          return;
        }

        log.i('[MessagingController] disconnectStreamUser() disconnecting user');
        await streamChatClient.disconnectUser();
      });

  Future<void> connectStreamUser({
    bool updateDevices = true,
  }) async =>
      connectionMutex.synchronized(() async {
        final fba.FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
        final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
        final ProfileController profileController = ref.read(profileControllerProvider.notifier);
        final log = ref.read(loggerProvider);

        if (firebaseAuth.currentUser == null || profileController.state.userProfile == null) {
          log.e('[MessagingController] connectStreamUser() user or profile is null');
          return;
        }

        log.i('[MessagingController] onUserChanged() user is not null');
        final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
        final HttpsCallable callable = firebaseFunctions.httpsCallable('stream-getToken');
        final HttpsCallableResult response = await callable.call();
        log.i('[MessagingController] onUserChanged() result: $response');

        if (response.data is! String || response.data.isEmpty) {
          return;
        }

        final String userToken = response.data;

        final User streamUserRequest = buildMessagingUser(
          id: firebaseAuth.currentUser!.uid,
          name: profileController.state.userProfile?.displayName ?? '',
          imageUrl: firebaseAuth.currentUser?.photoURL ?? '',
        );

        await streamChatClient.connectUser(streamUserRequest, userToken);

        log.i('[MessagingController] onUserChanged() connected user: ${streamChatClient.state.currentUser}');
        if (updateDevices) {
          final String fcmToken = profileController.state.userProfile?.fcmToken ?? '';
          unawaited(updateStreamDevices(fcmToken));
        }
      });

  Future<void> updateStreamDevices(String fcmToken) async {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final log = ref.read(loggerProvider);

    log.i('[MessagingController] onUserChanged() updating devices');
    if (streamChatClient.wsConnectionStatus != ConnectionStatus.connected) {
      log.e('[MessagingController] onUserChanged() not connected');
      return;
    }

    if (fcmToken.isEmpty) {
      log.e('[MessagingController] onUserChanged() fcmToken is empty');
      return;
    }

    final ListDevicesResponse devicesResponse = await streamChatClient.getDevices();
    for (final Device device in devicesResponse.devices) {
      if (device.id != fcmToken) {
        log.i('[MessagingController] onUserChanged() removing device: ${device.id}');
        await streamChatClient.removeDevice(device.id);
      }
    }

    if (!devicesResponse.devices.any((Device device) => device.id == fcmToken)) {
      log.i('[MessagingController] onUserChanged() adding device: $fcmToken');
      await streamChatClient.addDevice(fcmToken, PushProvider.firebase, pushProviderName: pushProviderName);
    } else {
      log.i('[MessagingController] onUserChanged() device already exists: $fcmToken');
    }
  }

  Map<String, dynamic> buildUserExtraData({
    String? name,
    String? imageUrl,
  }) {
    final fba.FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final UserProfile? userProfile = ref.read(profileControllerProvider).userProfile;

    String actualName = name ?? userProfile?.displayName ?? '';
    String actualImageUrl = imageUrl ?? userProfile?.profileImage ?? '';

    if (actualName.isEmpty) {
      actualName = firebaseAuth.currentUser?.displayName ?? '';
    }

    if (actualImageUrl.isEmpty) {
      actualImageUrl = firebaseAuth.currentUser?.photoURL ?? '';
    }

    return {
      'name': actualName,
      'image': actualImageUrl,
    };
  }

  User buildMessagingUser({
    required String id,
    String name = '',
    String? imageUrl = '',
  }) {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    if (streamChatClient.state.currentUser != null) {
      return streamChatClient.state.currentUser!;
    }

    final Map<String, dynamic> extraData = buildUserExtraData();
    return User(id: id, extraData: extraData);
  }
}
