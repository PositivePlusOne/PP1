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
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/stream_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/extensions/time_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_numeric_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_selectable_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_verified_indicator.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';

class PositiveChannelListTile extends ConsumerWidget {
  const PositiveChannelListTile({
    this.channel,
    this.isEnabled = true,
    this.onTap,
    this.isSelected,
    super.key,
  });

  final Channel? channel;
  final bool isEnabled;
  final void Function(BuildContext context)? onTap;

  final bool? isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final ProfileControllerState profileControllerState = ref.watch(profileControllerProvider);

    final String currentProfileId = profileControllerState.currentProfile?.flMeta?.id ?? '';
    final List<Member> members = channel?.state?.members.toList() ?? [];
    final List<Profile> profiles = members.map((e) => cacheController.get<Profile>(e.userId!)).nonNulls.toList();
    final List<Profile> otherProfiles = profiles.where((element) => element.flMeta?.id != currentProfileId).toList();
    final List<Profile> otherAvailableProfiles = [];

    for (final Profile profile in otherProfiles) {
      final String userId = profile.flMeta?.id ?? '';
      if (userId.isEmpty) {
        continue;
      }

      final String expectedRelationshipId = [currentProfileId, userId].asGUID;
      final Relationship? relationship = cacheController.get<Relationship>(expectedRelationshipId);
      final Set<RelationshipState> states = relationship?.relationshipStatesForEntity(currentProfileId) ?? {};
      final bool isTargetBlocked = states.contains(RelationshipState.targetBlocked);
      if (!isTargetBlocked) {
        otherAvailableProfiles.add(profile);
      }
    }

    final Message? latestMessage = channel?.state?.messages.reversed.firstOrNull;
    // final bool isOneToOne = channel?.state?.members.length == 2;

    String title = '';
    String description = '';
    String time = '';

    if (otherAvailableProfiles.length == 1) {
      title = otherAvailableProfiles.first.displayName.asHandle;
    } else if (otherAvailableProfiles.length > 1 && otherAvailableProfiles.length < 4) {
      title = otherAvailableProfiles.map((e) => e.displayName.asHandle).join(', ');
    } else if (otherAvailableProfiles.length >= 4) {
      final List<String> handles = otherAvailableProfiles.take(3).map((e) => e.displayName.asHandle).toList();
      final int remaining = otherProfiles.length - 3;
      handles.add(localizations.shared_placeholders_member_count_more(remaining));
      title = handles.join(', ');
    }

    if (latestMessage != null) {
      final String userId = latestMessage.user?.id ?? '';
      final String expectedRelationshipId = [currentProfileId, userId].asGUID;
      final Relationship? relationship = cacheController.get<Relationship>(expectedRelationshipId);
      final Set<RelationshipState> states = relationship?.relationshipStatesForEntity(currentProfileId) ?? {};
      final bool isTargetBlocked = states.contains(RelationshipState.targetBlocked);
      if (isTargetBlocked) {
        description = localizations.shared_placeholders_blocked_user;
      } else {
        description = latestMessage.getFormattedDescription(localizations);
        time = latestMessage.createdAt.timeAgoFromNow;
      }
    }

    // if ((showProfileTagline || description.isEmpty) && isOneToOne && otherProfiles.isNotEmpty) {
    //   final Profile profile = otherProfiles.first;
    //   description = profile.getTagline(localizations);
    // }

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

      final Profile profile = otherAvailableProfiles[i];
      final Widget indicator = PositiveProfileCircularIndicator(profile: profile, size: kIconHuge);
      indicatorWidth += overlapValue;
      indicators.add(indicator);
    }

    if (indicators.isEmpty) {
      indicators.add(const PositiveProfileCircularIndicator(size: kIconHuge));
    }

    indicatorWidth = indicatorWidth.clamp(kIconHuge, kIconHuge * 3.0);

    final ValueKey<String> valueKey = ValueKey('pp1-channel-list-tile-${members.length}-${channel?.id}-${latestMessage?.id}');

    bool isVerified = false;
    Color accentColor = colors.teal;
    Color complementaryColor = accentColor.complimentTextColor;
    if (otherAvailableProfiles.length == 1) {
      isVerified = otherAvailableProfiles.first.isVerified;
      accentColor = otherAvailableProfiles.first.accentColor.toSafeColorFromHex();
      complementaryColor = accentColor.complimentTextColor;
    }

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
            if (otherAvailableProfiles.isNotEmpty) ...<Widget>[
              const SizedBox(width: kPaddingSmall),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            title,
                            maxLines: 2,
                            style: typography.styleTitle.copyWith(color: colors.colorGray7),
                          ),
                        ),
                        if (isVerified) ...<Widget>[
                          const SizedBox(width: kPaddingSmall),
                          PositiveVerifiedBadge(accentColor: accentColor, complementaryColor: complementaryColor),
                        ],
                      ],
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
