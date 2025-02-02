// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/database/common/fl_meta.dart';
import 'package:app/dtos/database/enrichment/promotions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/helpers/profile_helpers.dart';
import 'package:app/providers/analytics/analytic_properties.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_promoted_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_verified_indicator.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/positive_button.dart';

class ActivityPostHeadingWidget extends ConsumerWidget {
  const ActivityPostHeadingWidget({
    required this.activity,
    required this.currentProfile,
    required this.publisher,
    required this.publisherRelationship,
    required this.origin,
    required this.onOptions,
    this.padding = const EdgeInsets.symmetric(horizontal: kPaddingMedium),
    this.promotion,
    this.tags = const [],
    this.isOptionsHidden = false,
    this.isRepost = false,
    this.isShared = false,
    super.key,
  });

  final Profile? currentProfile;
  final Profile? publisher;
  final String origin;

  final Relationship? publisherRelationship;

  final Activity? activity;
  final EdgeInsets padding;

  final Promotion? promotion;
  final List<String> tags;

  final FutureOr<void> Function() onOptions;
  final bool isOptionsHidden;

  final bool isRepost;
  final bool isShared;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typeography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    String displayName = localisations.shared_placeholders_empty_display_name;
    String postDateTooltip = "";

    // we are promoted when there is a promotion or there is a tag that signals that it is
    final isPromotion = promotion != null || tags.indexWhere((tag) => TagHelpers.isPromoted(tag)) != -1;

    if (publisher?.displayName.isNotEmpty == true) {
      displayName = getSafeDisplayNameFromProfile(publisher);
    }

    final FlMeta? flMetaData = activity?.flMeta;
    if (flMetaData != null && flMetaData.createdDate != null) {
      postDateTooltip = flMetaData.createdDate!.asDateDifference(context);
      if (flMetaData.lastModifiedDate != null && flMetaData.lastModifiedDate!.isNotEmpty && flMetaData.createdDate! != flMetaData.lastModifiedDate!) {
        postDateTooltip = '${flMetaData.createdDate!.asDateDifference(context)} ${localisations.shared_post_tooltips_edited}';
      }
    }

    final bool isVerified = (publisher?.isVerified ?? false) == true;

    bool isBlocked = false;
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    if (publisherRelationship != null && currentProfileId.isNotEmpty) {
      final Set<RelationshipState> relationshipStates = publisherRelationship!.relationshipStatesForEntity(currentProfileId);
      isBlocked = relationshipStates.contains(RelationshipState.targetBlocked);
    }

    return Material(
      type: MaterialType.canvas,
      color: Colors.transparent,
      child: Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            PositiveProfileCircularIndicator(
              profile: isBlocked ? null : publisher,
              analyticProperties: generatePropertiesForPostSource(activity: activity),
            ),
            const SizedBox(width: kPaddingSmall),
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          isBlocked ? localisations.shared_placeholders_empty_display_name : displayName,
                          style: typeography.styleTitle.copyWith(color: colours.colorGray7),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isVerified) ...<Widget>[
                        const SizedBox(width: kPaddingSmall),
                        PositiveVerifiedBadge(accentColor: colours.teal, complementaryColor: colours.colorGray7),
                      ],
                    ],
                  ),
                  if (!isPromotion) ...<Widget>[
                    const SizedBox(height: kPaddingThin),
                    Text(
                      postDateTooltip,
                      style: typeography.styleSubtext.copyWith(color: colours.colorGray6),
                    ),
                  ],
                  if (isPromotion) ...<Widget>[
                    const SizedBox(height: kPaddingExtraSmall),
                    PositivePromotedIndicator(
                      invertColour: isShared,
                    ),
                  ],
                ],
              ),
            ),
            if (!isOptionsHidden && currentProfile != null) ...<Widget>[
              PositiveButton.appBarIcon(
                colors: colours,
                icon: UniconsLine.ellipsis_h,
                style: PositiveButtonStyle.text,
                size: PositiveButtonSize.medium,
                onTapped: onOptions,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
