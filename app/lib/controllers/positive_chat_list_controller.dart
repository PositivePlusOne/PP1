// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/extensions/future_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/user/profile_controller.dart';
import '../services/third_party.dart';

class PositiveChatListController extends StreamChannelListController {
  PositiveChatListController({
    required StreamChatClient client,
    Filter? filter,
    List<SortOption<ChannelState>>? channelStateSort,
    int limit = defaultChannelPagedLimit,
  }) : super(
          client: client,
          filter: filter,
          channelStateSort: channelStateSort,
          limit: limit,
        );

  @override
  Future<void> doInitialLoad() async {
    await super.doInitialLoad();
    await attemptToCacheProfiles();
  }

  @override
  Future<void> loadMore(int nextPageKey) async {
    await super.loadMore(nextPageKey);
    await attemptToCacheProfiles();
  }

  Future<void> attemptToCacheProfiles() async {
    final logger = providerContainer.read(loggerProvider);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final FirebaseAuth firebaseAuth = providerContainer.read(firebaseAuthProvider);
    final String currentUserId = firebaseAuth.currentUser?.uid ?? '';

    final List<Channel> channels = value.mapOrNull((value) => value.items) ?? [];
    for (final channel in channels) {
      final members = channel.state?.members ?? [];
      for (final member in members) {
        final String userId = member.user?.id ?? '';
        if (userId.isEmpty || userId == currentUserId) {
          continue;
        }

        logger.i('PositiveChatListController.attemptToCacheProfiles(), userId: $userId');
        runWithMutex(() => profileController.getProfile(userId), key: userId);
      }
    }
  }
}
