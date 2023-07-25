// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:app/dtos/database/chat/archived_member.dart';
import 'package:app/dtos/database/chat/channel_extra_data.dart';
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
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/json_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/stream_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/providers/events/connections/channels_updated_event.dart';
import 'package:app/providers/profiles/events/profile_switched_event.dart';
import 'package:app/providers/profiles/jobs/profile_fetch_processor.dart';
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

  Iterable<Channel> get channels {
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    return streamChatClient.state.channels.values;
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
    await setupUserListeners();
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
    channelsSubscription = streamChatClient
        .queryChannels(
          filter: filter,
          messageLimit: 1,
          watch: true,
          presence: true,
          state: true,
          paginationParams: const PaginationParams(limit: 30),
        )
        .listen(onChannelsUpdated);
  }

  void forceChannelUpdate(Channel channel) {
    final log = ref.read(loggerProvider);
    final StreamChatClient streamChatClient = ref.read(streamChatClientProvider);
    log.d('[GetStreamController] forceChannelUpdate()');

    if (channel.cid?.isEmpty ?? true) {
      log.i('[GetStreamController] forceChannelUpdate() channel cid is empty');
      return;
    }

    streamChatClient.state.addChannels({
      channel.cid!: channel,
    });

    onChannelsUpdated(streamChatClient.state.channels.values.toList());
    processStateChannelLists();
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
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
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

      final Object? cachedMember = cacheController.getFromCache(memberId!);
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

    if (profileController.state.currentProfile == null) {
      log.e('[GetStreamController] attemptToUpdateStreamDevices() profile is null');
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
    final String imageUrl = profileController.state.currentProfile?.profileImage?.bucketPath ?? '';
    final String displayName = profileController.state.currentProfile?.displayName ?? '';
    final String accentColor = profileController.state.currentProfile?.accentColor ?? '#2BEDE1';

    final Map<String, dynamic> userData = buildUserExtraData(
      imageUrl: imageUrl,
      displayName: displayName,
      accentColor: accentColor,
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
}
