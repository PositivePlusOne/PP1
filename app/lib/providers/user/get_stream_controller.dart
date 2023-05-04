// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart' as gsf;
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
    @Default('') String eventPublisher,
  }) = _GetStreamControllerState;

  factory GetStreamControllerState.initialState() => const GetStreamControllerState();
}

@Riverpod(keepAlive: true)
class GetStreamController extends _$GetStreamController {
  final Lock connectionMutex = Lock();

  final StreamController<bool> onConnectionStateChanged = StreamController<bool>.broadcast();

  StreamSubscription<fba.User?>? userSubscription;
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
    final fba.FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    await userSubscription?.cancel();
    userSubscription = firebaseAuth.authStateChanges().listen(onUserChanged);

    await firebaseTokenSubscription?.cancel();
    firebaseTokenSubscription = firebaseMessaging.onTokenRefresh.listen((String token) async {
      await updateStreamDevices(token);
    });
  }

  Future<void> onUserChanged(fba.User? user) async {
    final log = ref.read(loggerProvider);
    log.d('[GetStreamController] onUserChanged()');

    log.e('[GetStreamController] onUserChanged() event is null');
    await disconnectStreamUser();
    await connectStreamUser(updateDevices: true);

    await Future.wait([
      attemptToUpdateStreamProfile(),
      followSystemFeeds(),
    ]);
  }

  Future<void> followSystemFeeds() async {
    final log = ref.read(loggerProvider);
    final gsf.StreamFeedClient streamFeedClient = ref.read(streamFeedClientProvider);
    final fba.FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    if (streamFeedClient.currentUser == null || firebaseAuth.currentUser == null) {
      log.e('[GetStreamController] followSystemFeeds() user is null');
      return;
    }

    if (state.eventPublisher.isEmpty) {
      log.i('[GetStreamController] followSystemFeeds() already following system feeds');
      return;
    }

    log.i('[GetStreamController] followSystemFeeds() following event feeds');
    final gsf.FlatFeed userEventsFeed = streamFeedClient.flatFeed('event', firebaseAuth.currentUser!.uid);
    final gsf.FlatFeed systemEventsFeed = streamFeedClient.flatFeed('event', state.eventPublisher);
    await userEventsFeed.follow(systemEventsFeed);

    log.i('[GetStreamController] followSystemFeeds() finished following system feeds');
  }

  Future<void> attemptToUpdateStreamProfile() async {
    final log = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    log.d('[GetStreamController] attemptToUpdateStreamProfile()');

    if (streamChatClient.state.currentUser == null) {
      log.e('[GetStreamController] attemptToUpdateStreamProfile() user is null');
      return;
    }

    final Map<String, Object?> currentData = streamChatClient.state.currentUser!.extraData;
    final Map<String, Object?> newData = buildUserExtraData();

    // Deep equality check
    if (const DeepCollectionEquality().equals(currentData, newData)) {
      log.i('[GetStreamController] attemptToUpdateStreamProfile() no changes');
      return;
    }

    final User streamUserRequest = buildStreamChatUser(id: streamChatClient.state.currentUser!.id, extraData: newData);
    await streamChatClient.updateUser(streamUserRequest);
    log.i('[GetStreamController] attemptToUpdateStreamProfile() updated user');
  }

  Future<void> disconnectStreamUser() => connectionMutex.synchronized(() async {
        final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
        final log = ref.read(loggerProvider);

        if (streamChatClient.wsConnectionStatus == ConnectionStatus.disconnected) {
          log.e('[GetStreamController] disconnectStreamUser() not connected');
          return;
        }

        log.i('[GetStreamController] disconnectStreamUser() disconnecting user');
        await streamChatClient.disconnectUser();
        onConnectionStateChanged.sink.add(false);
      });

  Future<void> connectStreamUser({
    bool updateDevices = true,
  }) async =>
      connectionMutex.synchronized(() async {
        final fba.FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
        final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
        final gsf.StreamFeedClient streamFeedClient = ref.read(streamFeedClientProvider);
        final ProfileController profileController = ref.read(profileControllerProvider.notifier);
        final log = ref.read(loggerProvider);

        if (firebaseAuth.currentUser == null) {
          log.e('[GetStreamController] connectStreamUser() user or profile is null');
          return;
        }

        // Check if user is already connected
        if (streamChatClient.wsConnectionStatus == ConnectionStatus.connected) {
          log.i('[GetStreamController] connectStreamUser() user is already connected');
          return;
        }

        log.i('[GetStreamController] onUserChanged() user is not null');
        final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
        final HttpsCallable callable = firebaseFunctions.httpsCallable('stream-getChatToken');
        final HttpsCallableResult response = await callable.call();
        log.i('[GetStreamController] getChatToken() result: $response');

        if (response.data is! String || response.data.isEmpty) {
          return;
        }

        final String userId = firebaseAuth.currentUser!.uid;
        final String userToken = response.data;

        final String imageUrl = profileController.state.userProfile?.profileImage ?? firebaseAuth.currentUser?.photoURL ?? '';
        final String name = profileController.state.userProfile?.displayName ?? firebaseAuth.currentUser?.displayName ?? '';
        final Map<String, dynamic> userData = buildUserExtraData(
          imageUrl: imageUrl,
          name: name,
        );

        final gsf.User feedUser = buildStreamFeedUser(id: firebaseAuth.currentUser!.uid);
        final User chatUser = buildStreamChatUser(id: firebaseAuth.currentUser!.uid, extraData: userData);

        await streamChatClient.connectUser(chatUser, userToken);

        final gsf.Token feedToken = gsf.Token(userToken);
        await streamFeedClient.setUser(feedUser, feedToken, extraData: userData);

        log.i('[GetStreamController] onUserChanged() connected user: ${streamChatClient.state.currentUser}');
        if (updateDevices) {
          final String fcmToken = profileController.state.userProfile?.fcmToken ?? '';
          unawaited(updateStreamDevices(fcmToken));
        }

        log.i('[GetStreamController] onUserChanged() finished');
        onConnectionStateChanged.sink.add(true);
      });

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
    String? name,
    String? imageUrl,
  }) {
    final fba.FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final Profile? profile = ref.read(profileControllerProvider).userProfile;

    String actualName = name ?? profile?.displayName ?? '';
    String actualImageUrl = imageUrl ?? profile?.profileImage ?? '';
    String accentColor = profile?.accentColor ?? "";

    if (actualName.isEmpty) {
      actualName = firebaseAuth.currentUser?.displayName ?? '';
    }

    if (actualImageUrl.isEmpty) {
      actualImageUrl = firebaseAuth.currentUser?.photoURL ?? '';
    }

    return {
      'name': actualName,
      'image': actualImageUrl,
      "accentColor": accentColor,
    };
  }

  User buildStreamChatUser({
    required String id,
    Map<String, dynamic> extraData = const {},
  }) {
    return User(id: id, extraData: extraData);
  }

  gsf.User buildStreamFeedUser({
    required String id,
    Map<String, dynamic> extraData = const {},
  }) {
    return gsf.User(id: id, data: extraData);
  }

  void setEventPublisher(String? data) {
    final log = ref.read(loggerProvider);
    log.i('[GetStreamController] setEventPublisher() data: $data');

    if (data == null) {
      return;
    }

    state = state.copyWith(eventPublisher: data);
    unawaited(followSystemFeeds());
  }
}
