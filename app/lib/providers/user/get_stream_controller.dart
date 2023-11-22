// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/dtos/database/chat/archived_member.dart';
import 'package:app/dtos/database/chat/channel_extra_data.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/stream_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/providers/events/connections/channels_updated_event.dart';
import 'package:app/providers/profiles/events/profile_switched_event.dart';
import 'package:app/providers/profiles/jobs/profile_fetch_processor.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/providers/system/event/get_stream_system_message_type.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/providers/user/user_controller.dart';
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
    @Default(false) bool hasFetchedInitialChannels,
    @Default(false) bool hasFetchedInitialRelationships,
    @Default([]) List<Channel> conversationChannels,
    @Default([]) List<Channel> conversationChannelsWithMessages,
    @Default([]) List<Member> conversationMembers,
  }) = _GetStreamControllerState;

  factory GetStreamControllerState.initialState() => const GetStreamControllerState();
}

@Riverpod(keepAlive: true)
class GetStreamController extends _$GetStreamController {
  StreamSubscription<ProfileSwitchedEvent>? profileSubscription;
  StreamSubscription<CacheKeyUpdatedEvent>? cacheKeySubscription;

  StreamSubscription<String>? firebaseTokenSubscription;
  StreamSubscription<List<Channel>>? channelsSubscription;

  String get pushProviderName {
    switch (ref.read(systemControllerProvider).environment) {
      case SystemEnvironment.develop:
        return 'Development';
      case SystemEnvironment.staging:
        return 'Staging';
      case SystemEnvironment.production:
        return 'Firebase';
    }
  }

  String? get currentStreamUserId {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    return streamChatClient.state.currentUser?.id;
  }

  Iterable<Channel> get channels {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    return streamChatClient.state.channels.values;
  }

  int get unreadBadgeCount {
    int count = 0;
    for (final Channel channel in channels) {
      count += channel.state?.unreadCount ?? 0;
    }

    return count;
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
    final validRelationshipChannels = channels.withValidRelationships;
    final validRelationshipMembers = validRelationshipChannels.members.map((e) => e.userId!);

    // Check if the lists have any common elements
    return relationship?.members.any((element) => validRelationshipMembers.contains(element.memberId)) ?? false;
  }

  Future<void> setupListeners() async {
    final FirebaseMessaging firebaseMessaging = ref.read(firebaseMessagingProvider);
    final EventBus eventBus = ref.read(eventBusProvider);

    await profileSubscription?.cancel();
    profileSubscription = eventBus.on<ProfileSwitchedEvent>().listen(onProfileChanged);

    await cacheKeySubscription?.cancel();
    cacheKeySubscription = eventBus.on<CacheKeyUpdatedEvent>().listen(onCacheKeyUpdated);

    await firebaseTokenSubscription?.cancel();
    firebaseTokenSubscription = firebaseMessaging.onTokenRefresh.listen(onTokenUpdateDetected);
  }

  Future<void> onTokenUpdateDetected(String token) async {
    final logger = ref.read(loggerProvider);
    logger.d('[GetStreamController] onTokenUpdateDetected()');

    await updateStreamDevices(token);
  }

  Future<void> onProfileChanged(ProfileSwitchedEvent event) async {
    final log = ref.read(loggerProvider);
    log.d('[GetStreamController] onProfileChanged()');

    // Check if the new profile is the same as the current logged in stream user
    final String streamUserId = currentStreamUserId ?? '';
    if (streamUserId == event.profileId) {
      log.i('[GetStreamController] onProfileChanged() profileId is the same as streamUserId');
      return;
    }

    await disconnectStreamUser();
    await resetUserListeners();

    if (event.profileId.isEmpty) {
      log.i('[GetStreamController] onProfileChanged() profileId is empty');
      return;
    }

    await connectStreamUser();
    await setupProfileListeners();
    await attemptToUpdateStreamDevices();
  }

  Future<void> resetUserListeners() async {
    final log = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);

    log.d('[GetStreamController] resetUserListeners()');
    if (streamChatClient.state.currentUser == null) {
      log.i('[GetStreamController] resetUserListeners() user is null');
      return;
    }

    await channelsSubscription?.cancel();
  }

  Future<void> setupProfileListeners() async {
    final log = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    log.d('[GetStreamController] setupProfileListeners()');

    await channelsSubscription?.cancel();
    if (profileController.currentProfileId?.isEmpty ?? true) {
      log.i('[GetStreamController] setupProfileListeners() profileId is empty');
      return;
    }

    try {
      final Filter filter = Filter.in_('members', [profileController.currentProfileId!]);
      final Stream<List<Channel>> channelQuery = streamChatClient.queryChannels(
        filter: filter,
        messageLimit: 1,
        watch: true,
        presence: true,
        state: true,
        paginationParams: const PaginationParams(limit: 30),
      );

      channelsSubscription = channelQuery.listen(onChannelsUpdated, onError: (err) {
        log.e('[GetStreamController] setupProfileListeners() error: $err');
        state = state.copyWith(hasFetchedInitialChannels: true);
      });
    } catch (e) {
      log.e('[GetStreamController] setupProfileListeners() error: $e');
      //? This can be thrown from the internal framework for a number of reasons
      //? We see it however when swapping profiles, and handle it with a loading state; so we can ignore it
      await channelsSubscription?.cancel();
      channelsSubscription = null;
    }
  }

  Future<Channel?> forceChannelUpdate(Channel channel) async {
    final log = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    log.d('[GetStreamController] forceChannelUpdate()');

    if (channel.cid?.isEmpty ?? true) {
      log.i('[GetStreamController] forceChannelUpdate() channel cid is empty');
      return null;
    }

    Channel? newChannel;

    try {
      final Stream<List<Channel>> searchQuery = streamChatClient.queryChannels(
        filter: Filter.equal('cid', channel.cid!),
        watch: false,
        state: true,
        paginationParams: const PaginationParams(limit: 30),
      );

      final List<Channel>? result = await searchQuery.firstOrNull;
      newChannel = result?.firstOrNull;
    } catch (e) {
      log.e('[GetStreamController] forceChannelUpdate() error: $e');
      return null;
    }

    if (newChannel == null) {
      log.i('[GetStreamController] forceChannelUpdate() newChannel is null');
      return null;
    }

    // Update the channel in the state
    streamChatClient.state.addChannels({
      channel.cid!: newChannel,
    });

    onChannelsUpdated(streamChatClient.state.channels.values.toList());
    processStateChannelLists();

    return newChannel;
  }

  void onChannelsUpdated(List<Channel> channels) {
    final log = ref.read(loggerProvider);
    final EventBus eventBus = ref.read(eventBusProvider);
    log.d('[GetStreamController] onChannelsUpdated(): ${channels.length}');
    eventBus.fire(ChannelsUpdatedEvent(channels));

    log.d('[GetStreamController] onChannelsUpdated() channel ids are different - attempting to load relationships');
    processStateChannelLists();
    attemptToLoadStreamChannelRelationships();
  }

  void processStateChannelLists() {
    final log = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    log.d('[GetStreamController] processStateChannelLists()');

    final Iterable<Channel> channels = streamChatClient.state.channels.values;
    final Iterable<Channel> conversationChannelsWithMessages = channels.withMessages;
    final Iterable<Member> conversationMembers = channels.members;

    state = state.copyWith(
      conversationChannels: channels.toList(),
      conversationChannelsWithMessages: conversationChannelsWithMessages.toList(),
      conversationMembers: conversationMembers.toList(),
      hasFetchedInitialChannels: true,
    );
  }

  Future<void> attemptToLoadStreamChannelRelationships() async {
    final log = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final ProfileFetchProcessor profileFetchProcessor = await ref.read(profileFetchProcessorProvider.future);
    final CacheController cacheController = ref.read(cacheControllerProvider);
    log.d('[GetStreamController] updateChannelMembership()');

    if (streamChatClient.state.currentUser == null) {
      log.w('[GetStreamController] onChannelsUpdated() user is null');
      state = state.copyWith(hasFetchedInitialRelationships: true);
      return;
    }

    // Get a list of all channel members
    final Iterable<Channel> channels = streamChatClient.state.channels.values;
    final Iterable<Member> channelMembers = channels.expand((Channel channel) => channel.state?.members ?? []);

    log.d('[GetStreamController] onChannelsUpdated() found ${channelMembers.length} channel members');
    final String currentUserId = streamChatClient.state.currentUser?.id ?? '';
    final Iterable<Member> otherChannelMembers = channelMembers.where((Member member) => member.userId != currentUserId);
    final Iterable<Member> unknownMembers = otherChannelMembers.where((Member member) {
      final String? memberId = member.userId;
      if (memberId?.isEmpty ?? true) {
        return false;
      }

      final Object? cachedMember = cacheController.get(memberId!);
      return cachedMember == null;
    });

    log.i('[GetStreamController] onChannelsUpdated() found ${unknownMembers.length} unknown members');
    final Set<String> unknownMemberIds = unknownMembers.map((Member member) => member.userId!).toSet();
    if (unknownMemberIds.isEmpty) {
      log.i('[GetStreamController] onChannelsUpdated() no unknown members');
      state = state.copyWith(hasFetchedInitialRelationships: true);
      return;
    }

    profileFetchProcessor.appendProfileIds(unknownMemberIds);
    await profileFetchProcessor.forceFetch();

    state = state.copyWith(hasFetchedInitialRelationships: true);
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

    if (!profileController.isCurrentlyUserProfile) {
      log.e('[GetStreamController] attemptToUpdateStreamDevices() not current auth user');
      return;
    }

    final String fcmToken = profileController.state.currentProfile?.fcmToken ?? '';
    await updateStreamDevices(fcmToken);
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

    state = state.copyWith(
      conversationChannels: [],
      conversationChannelsWithMessages: [],
      conversationMembers: [],
      hasFetchedInitialChannels: false,
      hasFetchedInitialRelationships: false,
    );
  }

  Future<void> connectStreamUser() async {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final SystemApiService systemApiService = await ref.read(systemApiServiceProvider.future);
    final log = ref.read(loggerProvider);

    final Profile? currentProfile = profileController.currentProfile;
    final String currentProfileId = profileController.currentProfileId ?? '';
    if (currentProfile == null || currentProfileId.isEmpty) {
      log.e('[GetStreamController] connectStreamUser() profileId is empty');
      return;
    }

    // Check if user is already connected
    if (streamChatClient.wsConnectionStatus != ConnectionStatus.disconnected) {
      log.i('[GetStreamController] connectStreamUser() user is already connected or connecting');
      return;
    }

    log.i('[GetStreamController] onProfileChanged() user is not null');
    final String token = await systemApiService.getStreamToken();

    // Check if user is disconnected, so we don't call connectUser() twice
    if (streamChatClient.wsConnectionStatus != ConnectionStatus.disconnected) {
      log.w('[GetStreamController] onProfileChanged() user is not disconnected');
      return;
    }
    // all's okay to create the user then
    final User chatUser = buildStreamChatUser(profile: currentProfile);
    await streamChatClient.connectUser(chatUser, token);
  }

  Future<void> updateStreamDevices(String fcmToken) async {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final log = ref.read(loggerProvider);

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    if (!profileController.isCurrentlyUserProfile) {
      log.i('[GetStreamController] onProfileChanged() not current auth user');
      return;
    }

    log.i('[GetStreamController] onProfileChanged() updating devices');
    if (streamChatClient.wsConnectionStatus != ConnectionStatus.connected) {
      log.e('[GetStreamController] onProfileChanged() not connected');
      return;
    }

    if (fcmToken.isEmpty) {
      log.e('[GetStreamController] onProfileChanged() fcmToken is empty');
      return;
    }

    try {
      final ListDevicesResponse devicesResponse = await streamChatClient.getDevices();
      for (final Device device in devicesResponse.devices) {
        if (device.id != fcmToken) {
          log.i('[GetStreamController] onProfileChanged() removing device: ${device.id}');
          await streamChatClient.removeDevice(device.id);
        }
      }

      if (!devicesResponse.devices.any((Device device) => device.id == fcmToken)) {
        log.i('[GetStreamController] onProfileChanged() adding device: $fcmToken');
        await streamChatClient.addDevice(fcmToken, PushProvider.firebase, pushProviderName: pushProviderName);
      } else {
        log.i('[GetStreamController] onProfileChanged() device already exists: $fcmToken');
      }
    } catch (e) {
      log.e('[GetStreamController] onProfileChanged() error: $e');
    }
  }

  Map<String, dynamic> buildUserExtraData({
    required String displayName,
    required String imageUrl,
    required String accentColor,
  }) {
    final fba.FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    String actualDisplayName = displayName;
    String actualImageUrl = imageUrl;

    if (actualDisplayName.isEmpty) {
      actualDisplayName = firebaseAuth.currentUser?.displayName ?? '';
    }

    if (actualImageUrl.isEmpty) {
      actualImageUrl = firebaseAuth.currentUser?.photoURL ?? '';
    }

    return {
      'name': actualDisplayName,
      'image': actualImageUrl,
      'accentColor': accentColor,
    };
  }

  User buildStreamChatUser({
    required Profile profile,
  }) {
    // from the profile we can get all the data we need to create a getstream user
    final String uid = profile.flMeta?.id ?? '';
    final String imageUrl = profile.profileImage?.bucketPath ?? '';
    final String displayName = profile.displayName;
    final String accentColor = profile.accentColor;
    // which we can build our map of extra data
    final Map<String, dynamic> extraData = buildUserExtraData(
      imageUrl: imageUrl,
      displayName: displayName,
      accentColor: accentColor,
    );
    // to create a richly described user
    return User(id: uid, name: displayName, image: imageUrl, extraData: extraData);
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

  Channel? getChannelForMembers(List<String> memberIds) {
    final log = ref.read(loggerProvider);
    log.d('[GetStreamController] getChannelForMembers() memberIds: $memberIds');

    // Check if conversation already exists
    return channels.firstWhereOrNull((element) {
      final List<String> userIds = element.state?.members.map((e) => e.userId!).toList() ?? [];
      if (userIds.deepMatch(memberIds)) {
        return true;
      }

      return false;
    });
  }

  Future<void> createConversation(List<String> memberIds, {bool shouldPopDialog = false}) async {
    final log = ref.read(loggerProvider);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final ChatViewModel chatViewModel = ref.read(chatViewModelProvider.notifier);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    log.d('[GetStreamController] createConversation() memberIds: $memberIds');

    if (profileController.currentProfileId == null) {
      log.e('[GetStreamController] createConversation() currentProfileId is null');
    }

    // Add the current user to the list of members
    final List<String> newMemberIds = {
      ...memberIds,
      profileController.currentProfileId!,
    }.toList();

    // Check if conversation already exists
    final Channel? channel = getChannelForMembers(newMemberIds);
    if (channel != null) {
      log.i('[GetStreamController] createConversation() conversation already exists');
      await chatViewModel.onChannelSelected(channel, shouldPopDialog: shouldPopDialog);
      return;
    }

    final res = await firebaseFunctions.httpsCallable('conversation-createConversation').call({'members': memberIds});
    if (res.data == null) {
      throw Exception('Failed to create conversation');
    }

    final conversationId = json.decodeSafe(res.data)['conversationId'] as String;
    await chatViewModel.onChatIdSelected(conversationId, shouldPopDialog: shouldPopDialog);
  }

  Future<void> lockConversation({required BuildContext context, required Channel channel}) async {
    final log = ref.read(loggerProvider);
    final AppLocalizations locale = AppLocalizations.of(context)!;
    final User streamUser = StreamChat.of(context).currentUser!;
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);

    if (profileController.state.currentProfile == null) {
      log.e('[GetStreamController] lockConversation() currentProfile is null');
      return;
    }

    await firebaseFunctions.httpsCallable('conversation-freezeChannel').call(
      {
        'channelId': channel.id,
        'text': locale.page_chat_lock_group_system_message(profileController.state.currentProfile!.displayName),
        'userId': streamUser.id,
      },
    );

    final ChatViewModel chatViewModel = ref.read(chatViewModelProvider.notifier);
    chatViewModel.notifyChannelUpdate(channel);
  }

  Future<void> leaveConversation({
    required BuildContext context,
    required Channel channel,
  }) async {
    final log = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final ConversationApiService conversationApiService = await ref.read(conversationApiServiceProvider.future);

    if (streamChatClient.state.currentUser == null || channel.id == null) {
      log.e('[GetStreamController] leaveConversation() currentProfile or channel id is null');
      return;
    }

    await conversationApiService.archiveMembers(
      conversationId: channel.id!,
      members: [streamChatClient.state.currentUser!.id],
    );

    // Create a new copy of the channel with the current user removed
    final Channel newChannel = streamChatClient.channel(
      channel.type,
      id: channel.id,
      extraData: ChannelExtraData(
        archivedMembers: [
          ArchivedMember(
            memberId: streamChatClient.state.currentUser!.id,
            dateArchived: DateTime.now(),
          ),
        ],
      ).toJson(),
    );

    final ChatViewModel chatViewModel = ref.read(chatViewModelProvider.notifier);
    chatViewModel.notifyChannelUpdate(newChannel);
  }

  void onCacheKeyUpdated(CacheKeyUpdatedEvent event) {
    switch (event.value.runtimeType) {
      case Relationship:
        onRelationshipUpdated(event.value as Relationship);
        break;
      case Profile:
        onProfileUpdated(event.value as Profile);
        break;
      default:
        break;
    }
  }

  void onProfileUpdated(Profile profile) {
    final log = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final UserController userController = ref.read(userControllerProvider.notifier);
    log.d('[GetStreamController] onProfileUpdated()');

    final String currentUserId = userController.currentUser?.uid ?? '';
    final String profileId = profile.flMeta?.id ?? '';

    if (currentUserId.isEmpty || currentUserId != profileId) {
      log.i('[GetStreamController] onProfileUpdated() currentUserId is empty or does not match profileId');
      return;
    }

    if (streamChatClient.state.currentUser == null) {
      log.i('[GetStreamController] onProfileUpdated() user is null');
      return;
    }
    log.i('[GetStreamController] onProfileUpdated() updating user');
    final User chatUser = buildStreamChatUser(profile: profileController.state.currentProfile ?? profile);
    streamChatClient.state.updateUser(chatUser);
  }

  // Some relationships will have a channel ID, some won't
  // When we get a relationship update and we are logged in, we can check the members of the channel
  // And if we do not have the channel in our list, we can add it
  Future<void> onRelationshipUpdated(Relationship relationship) async {
    final log = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    if (profileController.currentProfileId == null) {
      log.e('[GetStreamController] onRelationshipUpdated() currentProfileId is null');
      return;
    }

    if (relationship.channelId.isEmpty) {
      log.i('[GetStreamController] onRelationshipUpdated() relationship does not have a channel id');
      return;
    }

    // Check if we already have the channel
    final Channel? channel = streamChatClient.state.channels[relationship.channelId];
    if (channel != null) {
      log.i('[GetStreamController] onRelationshipUpdated() channel already exists');
      return;
    }

    final List<Channel>? channels = await streamChatClient
        .queryChannels(
          filter: Filter.in_('cid', [relationship.channelId]),
          watch: true,
          state: true,
          presence: true,
          messageLimit: 1,
        )
        .firstOrNull;

    if (channels == null || channels.isEmpty) {
      log.i('[GetStreamController] onRelationshipUpdated() channel does not exist');
      return;
    }

    log.i('[GetStreamController] onRelationshipUpdated() adding channel');
    onChannelsUpdated(channels);
  }
}
