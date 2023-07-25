// Flutter imports:
import 'package:app/extensions/time_extensions.dart';
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
import 'package:app/extensions/stream_extensions.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
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
    final List<Profile> otherProfiles = profiles.where((element) => element.flMeta?.id != currentUserId).toList();

    final Message? latestMessage = channel.state?.messages.reversed.firstOrNull;
    final bool isOneToOne = channel.state?.members.length == 2;

    String title = '';
    String description = '';
    String time = '';

    if (otherProfiles.length == 1) {
      title = otherProfiles.first.displayName.asHandle;
    } else if (otherProfiles.length > 1 && otherProfiles.length < 4) {
      title = otherProfiles.map((e) => e.displayName.asHandle).join(', ');
    } else if (otherProfiles.length >= 4) {
      final List<String> handles = otherProfiles.take(3).map((e) => e.displayName.asHandle).toList();
      final int remaining = otherProfiles.length - 3;
      handles.add(localizations.shared_placeholders_member_count_more(remaining));
      title = handles.join(', ');
    }

    if (latestMessage != null) {
      description = latestMessage.getFormattedDescription(localizations);
      time = latestMessage.createdAt.timeAgoFromNow;
    }

    if ((showProfileTagline || description.isEmpty) && isOneToOne && otherProfiles.isNotEmpty) {
      final Profile profile = otherProfiles.first;
      description = profile.getTagline(localizations);
    }

    final List<Widget> indicators = [];
    const double overlapValue = kIconHuge * 0.50;
    double indicatorWidth = kIconHuge * 0.50;

    for (int i = 0; i != 3; i++) {
      final bool outsideOfIndex = i >= otherProfiles.length;
      if (outsideOfIndex) {
        break;
      }

      // If the element is the last, use a custom indicator
      if (i == 2 && otherProfiles.length > 3) {
        final int remaining = otherProfiles.length - 2;
        if (remaining <= 0) {
          break;
        }

        indicatorWidth += overlapValue;
        indicators.add(PositiveNumericIndicator(count: remaining, size: kIconHuge));
        break;
      }

      final Profile profile = otherProfiles[i];
      final Widget indicator = PositiveProfileCircularIndicator(profile: profile, size: kIconHuge);
      indicatorWidth += overlapValue;
      indicators.add(indicator);
    }

    if (indicators.isEmpty) {
      indicators.add(const PositiveProfileCircularIndicator(size: kIconHuge));
    }

    indicatorWidth = indicatorWidth.clamp(kIconHuge, kIconHuge * 3.0);

    final ValueKey<String> valueKey = ValueKey('pp1-channel-list-tile-${members.length}-${channel.id}-${latestMessage?.id}');

    return PositiveTapBehaviour(
      key: valueKey,
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
              height: kIconHuge,
              width: indicatorWidth,
              child: Stack(
                children: <Widget>[
                  for (final Widget indicator in indicators)
                    Positioned(
                      top: 0.0,
                      bottom: 0.0,
                      left: 0.0 + (overlapValue * indicators.indexOf(indicator)),
                      child: indicator,
                    ),
                ],
              ),
            ),
            if (otherProfiles.isNotEmpty) ...<Widget>[
              const SizedBox(width: kPaddingSmall),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.only(right: kPaddingMassive),
                        child: Text(
                          title,
                          maxLines: 2,
                          style: typography.styleTitle.copyWith(color: colors.colorGray7),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            description,
                            maxLines: 1,
                            style: typography.styleSubtext.copyWith(color: colors.colorGray3),
                          ),
                        ),
                        const SizedBox(width: kPaddingSmall),
                        if (isSelected == null) ...<Widget>[
                          Text(
                            time,
                            maxLines: 1,
                            style: typography.styleSubtext.copyWith(color: colors.colorGray3),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
            if (isSelected != null) ...<Widget>[
              const SizedBox(width: kPaddingSmall),
              Align(
                alignment: Alignment.centerRight,
                child: PositiveSelectableIndicator(
                  backgroundColor: colors.white,
                  isSelected: isSelected!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
