// Dart imports:
import 'dart:async';

// Package imports:
import 'package:app/providers/profiles/events/profile_switched_event.dart';
import 'package:app/services/api.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:synchronized/synchronized.dart';

// Project imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/providers/system/system_controller.dart';
import '../../services/third_party.dart';
import '../profiles/profile_controller.dart';

// Project imports:

part 'get_stream_controller.freezed.dart';
part 'get_stream_controller.g.dart';

@freezed
class GetStreamControllerState with _$GetStreamControllerState {
  const factory GetStreamControllerState({
    @Default(false) bool isBusy,
  }) = _GetStreamControllerState;

  factory GetStreamControllerState.initialState() => const GetStreamControllerState();
}

@Riverpod(keepAlive: true)
class GetStreamController extends _$GetStreamController {
  StreamSubscription<ProfileSwitchedEvent>? profileSubscription;
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
  GetStreamControllerState build() {
    return GetStreamControllerState.initialState();
  }

  Future<void> setupListeners() async {
    final FirebaseMessaging firebaseMessaging = ref.read(firebaseMessagingProvider);
    final EventBus eventBus = ref.read(eventBusProvider);

    await profileSubscription?.cancel();
    profileSubscription = eventBus.on<ProfileSwitchedEvent>().listen(onProfileChanged);

    await firebaseTokenSubscription?.cancel();
    firebaseTokenSubscription = firebaseMessaging.onTokenRefresh.listen((String token) async {
      await updateStreamDevices(token);
    });
  }

  Future<void> onProfileChanged(ProfileSwitchedEvent event) async {
    final log = ref.read(loggerProvider);
    log.d('[GetStreamController] onProfileChanged()');

    await disconnectStreamUser();

    if (event.profileId.isEmpty) {
      log.i('[GetStreamController] onProfileChanged() profileId is empty');
      return;
    }

    await connectStreamUser();
    await attemptToUpdateStreamProfile();
    await attemptToUpdateStreamDevices();
  }

  Future<void> attemptToUpdateStreamDevices() async {
    final log = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);

    log.d('[GetStreamController] attemptToUpdateStreamDevices()');
    if (streamChatClient.state.currentUser == null) {
      log.e('[GetStreamController] attemptToUpdateStreamDevices() user is null');
      return;
    }

    if (profileController.currentProfile == null) {
      log.e('[GetStreamController] attemptToUpdateStreamDevices() profile is null');
      return;
    }

    final String fcmToken = profileController.currentProfile?.fcmToken ?? '';
    await updateStreamDevices(fcmToken);
  }

  Future<void> attemptToUpdateStreamProfile() async {
    final log = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    log.d('[GetStreamController] attemptToUpdateStreamProfile()');

    if (streamChatClient.state.currentUser == null) {
      log.e('[GetStreamController] attemptToUpdateStreamProfile() user is null');
      return;
    }

    if (profileController.currentProfile == null) {
      log.e('[GetStreamController] attemptToUpdateStreamProfile() profile is null');
      return;
    }

    final Map<String, Object?> currentData = streamChatClient.state.currentUser!.extraData;
    final Map<String, Object?> newData = buildUserExtraData(
      accentColor: profileController.currentProfile!.accentColor,
      name: profileController.currentProfile!.name,
      imageUrl: profileController.currentProfile!.profileImage,
      birthday: profileController.currentProfile!.birthday,
      interests: profileController.currentProfile!.interests.toList(),
      genders: profileController.currentProfile!.genders.toList(),
      hivStatus: profileController.currentProfile!.hivStatus,
      locationName: profileController.currentProfile!.place?.description,
    );

    // Deep equality check
    if (const DeepCollectionEquality().equals(currentData, newData)) {
      log.i('[GetStreamController] attemptToUpdateStreamProfile() no changes');
      return;
    }

    try {
      final User streamUserRequest = buildStreamChatUser(id: streamChatClient.state.currentUser!.id, extraData: newData);
      await streamChatClient.updateUser(streamUserRequest);
      log.i('[GetStreamController] attemptToUpdateStreamProfile() updated user');
    } catch (e) {
      log.e('[GetStreamController] attemptToUpdateStreamProfile() error: $e');
      return;
    }
  }

  Future<void> disconnectStreamUser() async {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final log = ref.read(loggerProvider);

    if (streamChatClient.wsConnectionStatus == ConnectionStatus.disconnected) {
      log.w('[GetStreamController] disconnectStreamUser() not connected');
      return;
    }

    log.i('[GetStreamController] disconnectStreamUser() disconnecting user');
    await streamChatClient.disconnectUser();
  }

  Future<void> connectStreamUser() async {
    final fba.FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final SystemApiService systemApiService = await ref.read(systemApiServiceProvider.future);

    final log = ref.read(loggerProvider);

    if (firebaseAuth.currentUser == null) {
      log.e('[GetStreamController] connectStreamUser() user is null');
      return;
    }

    if (profileController.currentProfile?.flMeta?.id?.isEmpty ?? true) {
      log.e('[GetStreamController] connectStreamUser() profileId is empty');
      return;
    }

    // Check if user is already connected
    if (streamChatClient.wsConnectionStatus == ConnectionStatus.connected) {
      log.i('[GetStreamController] connectStreamUser() user is already connected');
      return;
    }

    log.i('[GetStreamController] onUserChanged() user is not null');
    final String token = await systemApiService.getStreamToken();
    final String uid = profileController.currentProfile?.flMeta?.id ?? '';
    final String imageUrl = profileController.currentProfile!.profileImage;
    final String name = profileController.currentProfile!.displayName;

    final Map<String, dynamic> userData = buildUserExtraData(
      imageUrl: imageUrl,
      name: name,
      accentColor: profileController.currentProfile!.accentColor,
      birthday: profileController.currentProfile!.birthday,
      interests: profileController.currentProfile!.interests.toList(),
      genders: profileController.currentProfile!.genders.toList(),
      hivStatus: profileController.currentProfile!.hivStatus,
      locationName: profileController.currentProfile!.place?.description,
    );

    final User chatUser = buildStreamChatUser(id: uid, extraData: userData);
    await streamChatClient.connectUser(chatUser, token);
  }

  Future<void> updateStreamDevices(String fcmToken) async {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final log = ref.read(loggerProvider);

    log.i('[GetStreamController] onUserChanged() updating devices');
    if (streamChatClient.wsConnectionStatus != ConnectionStatus.connected) {
      log.e('[GetStreamController] onUserChanged() not connected');
      return;
    }

    if (fcmToken.isEmpty) {
      log.e('[GetStreamController] onUserChanged() fcmToken is empty');
      return;
    }

    final ListDevicesResponse devicesResponse = await streamChatClient.getDevices();
    for (final Device device in devicesResponse.devices) {
      if (device.id != fcmToken) {
        log.i('[GetStreamController] onUserChanged() removing device: ${device.id}');
        await streamChatClient.removeDevice(device.id);
      }
    }

    if (!devicesResponse.devices.any((Device device) => device.id == fcmToken)) {
      log.i('[GetStreamController] onUserChanged() adding device: $fcmToken');
      await streamChatClient.addDevice(fcmToken, PushProvider.firebase, pushProviderName: pushProviderName);
    } else {
      log.i('[GetStreamController] onUserChanged() device already exists: $fcmToken');
    }
  }

  Map<String, dynamic> buildUserExtraData({
    required String name,
    required String imageUrl,
    required String accentColor,
    required String birthday,
    required List<String> interests,
    required List<String> genders,
    required String hivStatus,
    required String? locationName,
  }) {
    final fba.FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    String actualName = name;
    String actualImageUrl = imageUrl;

    if (actualName.isEmpty) {
      actualName = firebaseAuth.currentUser?.displayName ?? '';
    }

    if (actualImageUrl.isEmpty) {
      actualImageUrl = firebaseAuth.currentUser?.photoURL ?? '';
    }

    return {
      'name': actualName,
      'image': actualImageUrl,
      'accentColor': accentColor,
      'birthday': birthday,
      'interests': interests,
      'genders': genders,
      'hivStatus': hivStatus,
      'locationName': locationName,
    };
  }

  User buildStreamChatUser({
    required String id,
    Map<String, dynamic> extraData = const {},
  }) {
    return User(id: id, extraData: extraData);
  }
}
