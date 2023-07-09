import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/indicators/positive_numeric_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ConversationListTile extends ConsumerWidget {
  const ConversationListTile({
    required this.channel,
    super.key,
  });

  final Channel channel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);

    final String? currentUserId = ref.read(firebaseAuthProvider).currentUser?.uid;
    final List<Member> members = channel.state?.members.toList() ?? [];
    final List<Profile> profiles = members.map((e) => cacheController.getFromCache<Profile>(e.userId!)).nonNulls.toList();
    final List<Profile> otherProfiles = profiles.where((element) => element.id != currentUserId).toList();

    final Message? latestMessage = channel.state?.messages.reversed.firstOrNull;
    final Profile? latestMessageProfile = latestMessage != null ? cacheController.getFromCache<Profile>(latestMessage.user!.id) : null;

    String title = '';
    String description = '';

    if (currentUserId == null || otherProfiles.isEmpty) {
      return const SizedBox();
    }

    final List<Widget> indicators = [];
    for (int i = 0; i != 3; i++) {
      final bool outsideOfIndex = i >= otherProfiles.length;
      if (outsideOfIndex) {
        break;
      }

      // If the element is the last, use a custom indicator
      if (i == 2) {
        final int remaining = otherProfiles.length - 2;
        indicators.add(PositiveNumericIndicator(count: remaining));
        break;
      }

      final Profile profile = otherProfiles[i];
      final Widget indicator = PositiveProfileCircularIndicator(profile: profile);
      indicators.add(indicator);
    }

    return Container();
  }
}
