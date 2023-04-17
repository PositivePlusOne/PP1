import 'package:app/main.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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

    final List<Channel> channels = value.mapOrNull((value) => value.items) ?? [];
    for (final channel in channels) {
      final members = channel.state?.members ?? [];
      for (final member in members) {
        final String? userId = member.user?.id;
        if (userId == null) {
          continue;
        }

        try {
          await profileController.getProfile(userId);
        } catch (e, stackTrace) {
          logger.e('Failed to cache profile for $userId', e, stackTrace);
        }
      }
    }
  }
}
