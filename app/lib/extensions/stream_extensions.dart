// Package imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/dtos/database/chat/archived_member.dart';
import 'package:app/dtos/database/chat/channel_extra_data.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';

extension ChannelListExtensions on Iterable<Channel> {
  Map<String, Channel> get asMap {
    return Map<String, Channel>.fromEntries(map((Channel channel) => MapEntry<String, Channel>(channel.cid!, channel)));
  }

  Iterable<Channel> get onlyUnreadMessages {
    return where((Channel channel) => (channel.state?.unreadCount ?? 0) > 0).toList();
  }

  Iterable<Channel> get onlyMessages {
    return where((Channel channel) => channel.state?.messages.isNotEmpty ?? false).toList();
  }

  Iterable<Channel> get onlyOneOnOneMessages {
    return where((Channel channel) => channel.state?.members.length == 2).toList();
  }

  Iterable<Channel> get onlyGroupMessages {
    return where((Channel channel) => channel.state?.members.length != 2).toList();
  }

  Iterable<Channel> get removeSelfArchived {
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
    });
  }

  Iterable<Channel> get removeClosed {
    return where((Channel channel) {
      final ChannelExtraData extraData = ChannelExtraData.fromJson(channel.extraData);
      final int memberCount = channel.state?.members.length ?? 0;
      final int archivedMemberCount = extraData.archivedMembers?.length ?? 0;
      return memberCount > archivedMemberCount;
    });
  }

  Iterable<Channel> get withValidRelationships {
    if (isEmpty) {
      return this;
    }

    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final RelationshipController relationshipController = providerContainer.read(relationshipControllerProvider.notifier);
    final String currentProfileId = profileController.currentProfileId ?? '';

    if (currentProfileId.isEmpty) {
      return [];
    }

    return where((Channel channel) {
      final List<String> members = channel.state?.members.map((Member member) => member.userId ?? '').where((element) => element.isNotEmpty).toList() ?? [];
      final ChannelExtraData extraData = ChannelExtraData.fromJson(channel.extraData);

      if (members.isEmpty) {
        return false;
      }

      if (extraData.archivedMembers?.any((ArchivedMember member) => member.memberId == currentProfileId) ?? false) {
        return false;
      }

      if ((channel.memberCount ?? 0) > 2) {
        return true;
      }

      final String relationshipIdentifier = relationshipController.buildRelationshipIdentifier([...members]);
      if (relationshipIdentifier.isEmpty) {
        return false;
      }

      final Relationship? relationship = cacheController.getFromCache(relationshipIdentifier);
      if (relationship == null || !relationship.isValidConnectedRelationship) {
        return false;
      }

      return true;
    });
  }

  Iterable<Channel> get withMessages {
    return where((Channel channel) => channel.state?.messages.isNotEmpty ?? false);
  }

  Iterable<Channel> get timeDescending {
    return toList()..sort((Channel a, Channel b) => (b.lastMessageAt?.millisecondsSinceEpoch ?? 0).compareTo(a.lastMessageAt?.millisecondsSinceEpoch ?? 0));
  }

  Iterable<Member> get members {
    final Map<String, Member> members = {};
    for (final Channel channel in this) {
      for (final Member member in channel.state?.members ?? []) {
        members[member.userId!] = member;
      }
    }

    return members.values;
  }
}

extension MemberListExt on Iterable<Member> {
  Iterable<String> get userIds {
    return map((Member member) => member.userId!);
  }
}

extension MessageExt on Message {
  String buildTileDescription(AppLocalizations localizations) {
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);
    final Profile? profile = cacheController.getFromCache<Profile>(user!.id);
    final String handle = profile?.displayName.asHandle ?? localizations.shared_placeholders_empty_display_name;

    if (isDeleted) {
      return localizations.shared_placeholders_deleted_message(handle);
    }

    // Check for attachments
    if (attachments.isNotEmpty) {
      final Attachment attachment = attachments.first;
      if (attachment.type == 'image') {
        return localizations.shared_placeholders_image_message(handle);
      } else if (attachment.type == 'video') {
        return localizations.shared_placeholders_video_message(handle);
      } else if (attachment.type == 'file') {
        return localizations.shared_placeholders_file_message(handle);
      }
    }

    if (text?.isNotEmpty ?? false) {
      return text!;
    }

    return localizations.shared_placeholders_empty_message(handle);
  }
}
