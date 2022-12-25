import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ppoa/business/extensions/brand_extensions.dart';
import 'package:ppoa/business/state/content/recommended_content.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/constants/ppo_design_constants.dart';

import '../../components/atoms/decorations/ppo_event_location_pill.dart';
import '../../components/atoms/decorations/ppo_event_start_pill.dart';
import '../../components/atoms/images/author_image.dart';
import '../enumerations/home_page_recommended_feature_metadata.dart';

class HomeRecommendedFeaturePanel extends StatelessWidget {
  const HomeRecommendedFeaturePanel({
    required this.recommendedContent,
    required this.branding,
    super.key,
  });

  final RecommendedContent recommendedContent;
  final DesignSystemBrand branding;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final List<HomePageRecommendedFeatureMetadata> metadata = <HomePageRecommendedFeatureMetadata>[
      if (recommendedContent.eventTime != null) ...<HomePageRecommendedFeatureMetadata>[
        HomePageRecommendedFeatureMetadata.startTime,
      ],
      if (recommendedContent.eventLocation != null) ...<HomePageRecommendedFeatureMetadata>[
        HomePageRecommendedFeatureMetadata.location,
      ],
    ];

    final int maxLines = metadata.isNotEmpty ? 2 : 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          localizations.home_hub_recommendation_title,
          style: branding.typography.styleBody.copyWith(
            color: branding.colors.black.withOpacity(0.5),
          ),
        ),
        Text(
          recommendedContent.contentTitle,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: branding.typography.styleHero.copyWith(color: branding.colors.black),
        ),
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: metadata.length,
            separatorBuilder: (_, __) => kPaddingSmall.asHorizontalWidget,
            itemBuilder: (_, int index) {
              final HomePageRecommendedFeatureMetadata md = metadata[index];
              switch (md) {
                case HomePageRecommendedFeatureMetadata.startTime:
                  return Align(
                    alignment: Alignment.center,
                    child: PPOEventStartPill(branding: branding, eventTime: recommendedContent.eventTime!),
                  );
                case HomePageRecommendedFeatureMetadata.location:
                  return Align(
                    alignment: Alignment.center,
                    child: PPOEventLocationPill(branding: branding, eventLocation: recommendedContent.eventLocation!),
                  );
              }
            },
          ),
        ),
        Row(
          children: <Widget>[
            AuthorImage(
              authorDisplayName: recommendedContent.contentCreatorDisplayName,
              branding: branding,
              imageUrl: recommendedContent.contentCreatorDisplayImage,
            ),
            kPaddingSmall.asHorizontalWidget,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '@${recommendedContent.contentCreatorDisplayName}',
                    style: branding.typography.styleTitle.copyWith(
                      color: branding.colors.black,
                    ),
                  ),
                  Text(
                    // TODO(ryan): Fix this
                    '1 Month Ago',
                    style: branding.typography.styleSubtext.copyWith(
                      color: branding.colors.black.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
