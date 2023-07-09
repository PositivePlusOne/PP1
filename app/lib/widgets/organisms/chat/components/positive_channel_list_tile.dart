// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/positive_checkbox.dart';
import 'package:app/widgets/atoms/indicators/positive_numeric_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_selectable_indicator.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';

class PositiveChannelListTile extends ConsumerWidget {
  const PositiveChannelListTile({
    required this.channel,
    this.isEnabled = true,
    this.onTap,
    this.isSelected,
    this.showProfileTagline = false,
    super.key,
  });

  final Channel channel;
  final bool isEnabled;
  final VoidCallback? onTap;

  final bool? isSelected;
  final bool showProfileTagline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final String? currentUserId = ref.read(firebaseAuthProvider).currentUser?.uid;
    final List<Member> members = channel.state?.members.toList() ?? [];
    final List<Profile> profiles = members.map((e) => cacheController.getFromCache<Profile>(e.userId!)).nonNulls.toList();
    final List<Profile> otherProfiles = profiles.where((element) => element.id != currentUserId).toList();

    final Message? latestMessage = channel.state?.messages.reversed.firstOrNull;
    final Profile? latestMessageProfile = latestMessage != null ? cacheController.getFromCache<Profile>(latestMessage.user!.id) : null;
    final String latestMessageText = latestMessage?.text ?? '';
    final bool isOneToOne = channel.state?.members.length == 2;

    String title = '';
    String description = '';
    String time = '';

    if (otherProfiles.length == 1) {
      title = otherProfiles.first.displayName.asHandle;
    } else if (otherProfiles.length > 1) {
      title = otherProfiles.map((e) => e.displayName.asHandle).join(', ');
    }

    if (latestMessage != null) {
      description = '${latestMessageProfile?.displayName.asHandle}: $latestMessageText';
      time = Jiffy.parseFromDateTime(latestMessage.createdAt).fromNow();
    }

    if (showProfileTagline && isOneToOne && otherProfiles.isNotEmpty) {
      final Profile profile = otherProfiles.first;
      description = profile.getTagline(localizations);
    }

    final List<Widget> indicators = [];
    double indicatorWidth = kIconLarge;
    const double overlapValue = kIconLarge * 0.75;

    for (int i = 0; i != 3; i++) {
      final bool outsideOfIndex = i >= otherProfiles.length;
      if (outsideOfIndex) {
        break;
      }

      indicatorWidth += overlapValue;

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

    return PositiveTapBehaviour(
      isEnabled: isEnabled,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(kPaddingSmall),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: indicatorWidth,
              child: Stack(
                children: <Widget>[
                  for (final Widget indicator in indicators)
                    Positioned(
                      left: 0.0 + (overlapValue * indicators.indexOf(indicator)),
                      child: indicator,
                    ),
                ],
              ),
            ),
            const SizedBox(width: kPaddingSmall),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: typography.styleTitle.copyWith(color: colors.colorGray7),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          description,
                          style: typography.styleSubtext.copyWith(color: colors.colorGray3),
                        ),
                      ),
                      const SizedBox(width: kPaddingSmall),
                      if (isSelected != null) ...<Widget>[
                        PositiveSelectableIndicator(
                          backgroundColor: colors.white,
                          isSelected: isSelected!,
                        ),
                      ],
                      if (isSelected == null) ...<Widget>[
                        Text(
                          time,
                          style: typography.styleSubtext.copyWith(color: colors.colorGray3),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
