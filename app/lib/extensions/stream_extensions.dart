// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/dtos/database/chat/archived_member.dart';
import 'package:app/dtos/database/chat/channel_extra_data.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';

extension ChannelExtensions on Channel {
  bool get isCurrentlyArchived {
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final String currentProfileId = profileController.currentProfileId ?? '';

    if (currentProfileId.isEmpty) {
      return false;
    }

    final ChannelExtraData extraDataObj = ChannelExtraData.fromJson(extraData);
    return extraDataObj.archivedMembers?.any((ArchivedMember member) => member.memberId == currentProfileId) ?? false;
  }
}

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

  Iterable<Channel> withProfileTextSearch(String str) {
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final String currentProfileId = profileController.currentProfileId ?? '';

    if (str.isEmpty) {
      return this;
    }

    if (currentProfileId.isEmpty) {
      return this;
    }

    return where((Channel channel) {
      final List<String> members = channel.state?.members.map((Member member) => member.userId ?? '').where((element) => element.isNotEmpty).toList() ?? [];

      // Loop through other members
      for (final String memberId in members) {
        if (memberId == currentProfileId || memberId.isEmpty) {
          continue;
        }

        final Profile? otherProfile = cacheController.get<Profile>(memberId);
        if (otherProfile == null) {
          continue;
        }

        if (otherProfile.matchesStringSearch(str)) {
          return true;
        }
      }

      return false;
    });
  }

  Iterable<Channel> get withValidRelationships {
    if (isEmpty) {
      return this;
    }

    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final String currentProfileId = profileController.currentProfileId ?? '';

    if (currentProfileId.isEmpty) {
      return [];
    }

    return where((Channel channel) {
      final List<String> members = channel.state?.members.map((Member member) => member.userId ?? '').where((element) => element.isNotEmpty).toList() ?? [];
      if (members.isEmpty) {
        return false;
      }

      for (final String member in members) {
        if (member == currentProfileId || member.isEmpty) {
          continue;
        }

        final String relationshipIdentifier = [currentProfileId, member].asGUID;
        final Relationship? relationship = cacheController.get(relationshipIdentifier);
        final Profile? otherProfile = cacheController.get<Profile>(member);
        final bool isValidRelationship = relationship?.isValidConnectedRelationship ?? false;
        if (isValidRelationship && otherProfile != null) {
          return true;
        }
      }

      return false;
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
  String getFormattedDescription(AppLocalizations localizations) {
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final Profile? profile = cacheController.get<Profile>(user!.id);
    final String handle = profile?.displayName.asHandle ?? localizations.shared_placeholders_empty_display_name;
    final String formattedText = text?.trim() ?? '';
    final String displayName = profile?.displayName.asHandle ?? ''.asHandle;

    if (isDeleted) {
      return localizations.shared_placeholders_deleted_message(handle);
    }

    // Check for attachments if no text
    if (attachments.isNotEmpty && formattedText.isEmpty) {
      final Attachment attachment = attachments.first;
      if (attachment.type == 'image') {
        return localizations.shared_placeholders_image_message(handle);
      } else if (attachment.type == 'video') {
        return localizations.shared_placeholders_video_message(handle);
      } else if (attachment.type == 'file') {
        return localizations.shared_placeholders_file_message(handle);
      }
    }

    if (formattedText.isEmpty) {
      return localizations.shared_placeholders_empty_message(handle);
    }

    if (formattedText.startsWith('@')) {
      return formattedText;
    }

    return "$displayName $text";
  }
}
