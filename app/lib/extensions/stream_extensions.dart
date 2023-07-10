// Package imports:
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/dtos/database/chat/archived_member.dart';
import 'package:app/dtos/database/chat/channel_extra_data.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/helpers/relationship_helpers.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';

extension ChannelListExtensions on List<Channel> {
  Map<String, Channel> get asMap {
    return Map<String, Channel>.fromEntries(map((Channel channel) => MapEntry<String, Channel>(channel.cid!, channel)));
  }

  List<Channel> get onlyUnreadMessages {
    return where((Channel channel) => (channel.state?.unreadCount ?? 0) > 0).toList();
  }

  List<Channel> get onlyMessages {
    return where((Channel channel) => channel.state?.messages.isNotEmpty ?? false).toList();
  }

  List<Channel> get onlyOneOnOneMessages {
    return where((Channel channel) => channel.state?.members.length == 2).toList();
  }

  List<Channel> get onlyGroupMessages {
    return where((Channel channel) => channel.state?.members.length != 2).toList();
  }

  List<Channel> get removeSelfArchived {
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final String currentProfileId = profileController.currentProfileId ?? '';
    if (currentProfileId.isEmpty) {
      return this;
    }

    return where((Channel channel) {
      final ChannelExtraData extraData = ChannelExtraData.fromJson(channel.extraData);
      for (final ArchivedMember member in extraData.archivedMembers ?? []) {
        if (member.memberId == currentProfileId) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  List<Channel> get removeClosed {
    return where((Channel channel) {
      final ChannelExtraData extraData = ChannelExtraData.fromJson(channel.extraData);
      final int memberCount = channel.state?.members.length ?? 0;
      final int archivedMemberCount = extraData.archivedMembers?.length ?? 0;
      return memberCount > archivedMemberCount;
    }).toList();
  }

  List<Channel> get withValidRelationships {
    if (isEmpty) {
      return this;
    }

    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final String currentProfileId = profileController.currentProfileId ?? '';

    if (currentProfileId.isEmpty) {
      return [];
    }

    return where((Channel channel) {
      final List<String> members = channel.state?.members.map((Member member) => member.userId!).toList() ?? [];
      final ChannelExtraData extraData = ChannelExtraData.fromJson(channel.extraData);

      // If members is a group, then we don't need to check for a relationship
      if (members.length > 2) {
        return true;
      }

      if (extraData.archivedMembers?.any((ArchivedMember member) => member.memberId == currentProfileId) ?? false) {
        return false;
      }

      final String relationshipIdentifier = buildRelationshipIdentifier(members);
      if (relationshipIdentifier.isEmpty) {
        return false;
      }

      final Relationship? relationship = cacheController.getFromCache(relationshipIdentifier);
      if (relationship == null || !relationship.isValidConnectedRelationship) {
        return false;
      }

      return true;
    }).toList();
  }

  List<Channel> get withMessages {
    return where((Channel channel) => channel.state?.messages.isNotEmpty ?? false).toList();
  }

  List<String> get membersIds {
    final List<String> membersIds = [];
    for (final Channel channel in this) {
      membersIds.addAll(channel.state?.members.map((Member member) => member.userId!) ?? []);
    }

    return membersIds;
  }
}
