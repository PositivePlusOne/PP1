// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/stream_extensions.dart';
import 'package:app/providers/events/connections/channels_updated_event.dart';
import 'package:app/providers/profiles/events/profile_switched_event.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/event/get_stream_system_message_type.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/services/api.dart';
import 'package:app/widgets/organisms/chat/vms/chat_view_model.dart';
import '../../services/third_party.dart';
import '../profiles/profile_controller.dart';

// Project imports:

part 'get_stream_controller.freezed.dart';
part 'get_stream_controller.g.dart';

@freezed
class GetStreamControllerState with _$GetStreamControllerState {
  const factory GetStreamControllerState({
    @Default(false) bool isBusy,
    @Default([]) List<Channel> channels,
  }) = _GetStreamControllerState;

  factory GetStreamControllerState.initialState() => const GetStreamControllerState();
}

@Riverpod(keepAlive: true)
class GetStreamController extends _$GetStreamController {
  StreamSubscription<ProfileSwitchedEvent>? profileSubscription;
  StreamSubscription<String>? firebaseTokenSubscription;
  StreamSubscription<List<Channel>>? channelsSubscription;

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

  String? get currentUserId {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    return streamChatClient.state.currentUser?.id;
  }

  @override
  GetStreamControllerState build() {
    return GetStreamControllerState.initialState();
  }

  bool isRelationshipInvolvedInConversation(Relationship? relationship) {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final String currentProfileId = profileController.currentProfileId ?? '';
    if (currentProfileId.isEmpty) {
      return false;
    }

    // Get the member ID of the other person in the conversation
    final validRelationshipChannels = state.channels.withValidRelationships.toList();
    final validRelationshipMembers = validRelationshipChannels.membersIds.where((element) => element != currentProfileId);

    // Check if the lists have any common elements
    return relationship?.members.any((element) => validRelationshipMembers.contains(element.memberId)) ?? false;
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
    await resetUserListeners();

    if (event.profileId.isEmpty) {
      log.i('[GetStreamController] onProfileChanged() profileId is empty');
      return;
    }

    await connectStreamUser();
    setupUserListeners();

    await attemptToUpdateStreamProfile();
    await attemptToUpdateStreamDevices();
  }

  Future<void> resetUserListeners() async {
    final log = ref.read(loggerProvider);
    log.d('[GetStreamController] resetUserListeners()');

    await channelsSubscription?.cancel();
  }

  Future<void> setupUserListeners() async {
    final log = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    log.d('[GetStreamController] setupUserListeners()');

    await channelsSubscription?.cancel();
    if (profileController.currentProfileId?.isEmpty ?? true) {
      log.i('[GetStreamController] setupUserListeners() profileId is empty');
      return;
    }

    final Filter filter = Filter.in_('members', [profileController.currentProfileId!]);
    channelsSubscription = streamChatClient.queryChannels(filter: filter, watch: true).listen(onChannelsUpdated);
  }

  void onChannelsUpdated(List<Channel> channels) {
    final log = ref.read(loggerProvider);
    final EventBus eventBus = ref.read(eventBusProvider);
    log.d('[GetStreamController] onChannelsUpdated(): ${channels.length}');
    eventBus.fire(ChannelsUpdatedEvent(channels));

    state = state.copyWith(channels: channels);
    log.d('[GetStreamController] onChannelsUpdated() channel ids are different - attempting to load relationships');
    attemptToLoadStreamChannelRelationships();
  }

  Future<void> attemptToLoadStreamChannelRelationships() async {
    final log = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    log.d('[GetStreamController] updateChannelMembership()');

    if (streamChatClient.state.currentUser == null) {
      log.e('[GetStreamController] onChannelsUpdated() user is null');
      return;
    }

    // Get a list of all channel members
    final Iterable<Channel> channels = streamChatClient.state.channels.values;
    final Iterable<Member> channelMembers = channels.expand((Channel channel) => channel.state?.members ?? []);

    log.d('[GetStreamController] onChannelsUpdated() found ${channelMembers.length} channel members');

    // Remove any members that are not the current user
    final String currentUserId = streamChatClient.state.currentUser?.id ?? '';
    final Iterable<Member> otherChannelMembers = channelMembers.where((Member member) => member.userId != currentUserId);
    final Iterable<Member> unknownMembers = otherChannelMembers.where((Member member) {
      final String? memberId = member.userId;
      if (memberId?.isEmpty ?? true) {
        return false;
      }

      final Object? cachedMember = cacheController.getFromCache(memberId!);
      return cachedMember == null;
    });

    log.i('[GetStreamController] onChannelsUpdated() found ${unknownMembers.length} unknown members');
    final List<String> unknownMemberIds = unknownMembers.map((Member member) => member.userId!).toList();
    if (unknownMemberIds.isEmpty) {
      log.i('[GetStreamController] onChannelsUpdated() no unknown members');
      return;
    }

    await profileApiService.getProfiles(members: unknownMemberIds);
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

    if (profileController.state.currentProfile == null) {
      log.e('[GetStreamController] attemptToUpdateStreamDevices() profile is null');
      return;
    }

    final String fcmToken = profileController.state.currentProfile?.fcmToken ?? '';
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

    if (profileController.state.currentProfile == null) {
      log.e('[GetStreamController] attemptToUpdateStreamProfile() profile is null');
      return;
    }

    final Map<String, Object?> currentData = streamChatClient.state.currentUser!.extraData;
    final Map<String, Object?> newData = buildUserExtraData(
      accentColor: profileController.state.currentProfile!.accentColor,
      name: profileController.state.currentProfile!.name,
      imageUrl: profileController.state.currentProfile!.profileImage,
      birthday: profileController.state.currentProfile!.birthday,
      interests: profileController.state.currentProfile!.interests.toList(),
      genders: profileController.state.currentProfile!.genders.toList(),
      hivStatus: profileController.state.currentProfile!.hivStatus,
      locationName: profileController.state.currentProfile!.place?.description,
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
    state = state.copyWith(channels: []);
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

    if (profileController.state.currentProfile?.flMeta?.id?.isEmpty ?? true) {
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
    final String uid = profileController.state.currentProfile?.flMeta?.id ?? '';
    final String imageUrl = profileController.state.currentProfile!.profileImage;
    final String name = profileController.state.currentProfile!.displayName;

    final Map<String, dynamic> userData = buildUserExtraData(
      imageUrl: imageUrl,
      name: name,
      accentColor: profileController.state.currentProfile!.accentColor,
      birthday: profileController.state.currentProfile!.birthday,
      interests: profileController.state.currentProfile!.interests.toList(),
      genders: profileController.state.currentProfile!.genders.toList(),
      hivStatus: profileController.state.currentProfile!.hivStatus,
      locationName: profileController.state.currentProfile!.place?.description,
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

  Future<void> sendSystemMessage({
    required String channelId,
    List<String>? mentionedUserIds,
    required String text,
    GetStreamSystemMessageType? eventType,
  }) async {
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final log = ref.read(loggerProvider);

    if (profileController.state.currentProfile == null) {
      log.e('[GetStreamController] sendSystemMessage() currentProfile is null');
      return;
    }

    await firebaseFunctions.httpsCallable('conversation-sendEventMessage').call({
      "channelId": channelId,
      "text": text,
      "eventType": eventType?.toJson(),
      "mentionedUsers": mentionedUserIds ?? [],
    });
  }

  Future<void> createConversation(List<String> memberIds, {bool shouldPopDialog = false}) async {
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final ChatViewModel chatViewModel = ref.read(chatViewModelProvider.notifier);

    final res = await firebaseFunctions.httpsCallable('conversation-createConversation').call({'members': memberIds});
    if (res.data == null) {
      throw Exception('Failed to create conversation');
    }

    final String conversationId = (res.data as Map<String, dynamic>)['conversationId'] as String;
    await chatViewModel.onChatIdSelected(conversationId, shouldPopDialog: shouldPopDialog);
  }

  Future<void> lockConversation({required BuildContext context, required Channel channel}) async {
    final locale = AppLocalizations.of(context)!;
    final streamUser = StreamChat.of(context).currentUser!;
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final res = await firebaseFunctions.httpsCallable('conversation-freezeChannel').call(
      {
        'channelId': channel.id,
        'text': locale.page_chat_lock_group_system_message(streamUser.id),
        'userId': streamUser.id,
      },
    );

    if (res.data == null) {
      throw Exception('Failed to freeze conversation');
    }
  }

  Future<void> leaveConversation({
    required BuildContext context,
    required Channel channel,
  }) async {
    final streamUser = StreamChat.of(context).currentUser!;
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);

    await firebaseFunctions.httpsCallable('conversation-archiveMembers').call({
      "channelId": channel.id,
      "members": [streamUser.id],
    });
  }
}
