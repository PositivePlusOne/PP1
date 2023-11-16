// Flutter imports:
import 'package:app/constants/profile_constants.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/organisms/development/vms/development_view_model.dart';
import '../../../dtos/database/profile/profile.dart';
import '../../../providers/system/design_controller.dart';

class PositiveProfileTile extends ConsumerWidget implements PreferredSizeWidget {
  const PositiveProfileTile({
    required this.profile,
    this.brightness = Brightness.light,
    this.metadataOpacity = 0.7,
    this.metadata = const <String, String>{},
    this.padding = const EdgeInsets.symmetric(horizontal: kPaddingSmallMedium),
    this.imageOverridePath = '',
    this.enableProfileImageFullscreen = false,
    super.key,
  });

  final Brightness brightness;
  final double metadataOpacity;

  final Profile profile;
  final Map<String, String> metadata;
  final EdgeInsets padding;

  //* This is used to override the image path for the profile image, for example when the user is uploading a new image
  final String imageOverridePath;
  final bool enableProfileImageFullscreen;

  @override
  Size get preferredSize => const Size.fromHeight(kPaddingExtraLarge + kIconHeader);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppRouter appRouter = ref.read(appRouterProvider);

    final Color textColor = brightness == Brightness.light ? colors.black : colors.white;
    // final AppLocalizations localizations = AppLocalizations.of(context)!;
    // final String tagline = profile.getTagline(localizations);

    final List<Widget> children = <Widget>[];
    for (final String statisticKey in kSupportedProfileStatistics) {
      // Attempt to get the stat from the metadata
      final String? statistic = metadata[statisticKey];
      if (statistic == null) {
        continue;
      }

      final Widget child = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '$statisticKey:',
            style: typography.styleButtonRegular.copyWith(color: textColor.withOpacity(metadataOpacity)),
          ),
          const SizedBox(width: kPaddingExtraSmall),
          Text(
            statistic,
            style: typography.styleButtonBold.copyWith(color: textColor),
          ),
        ],
      );

      children.add(child);
    }

    final bool shouldDisplayProfileId = ref.watch(developmentViewModelProvider.select((value) => value.displaySelectablePostIDs));

    return Container(
      height: preferredSize.height,
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: preferredSize.height,
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              PositiveProfileCircularIndicator(
                profile: profile,
                size: kIconHeader,
                complimentRingColorForBackground: true,
                imageOverridePath: imageOverridePath,
                onTap: () => enableProfileImageFullscreen && profile.profileImage != null ? appRouter.push(MediaRoute(media: profile.profileImage!)) : () {},
              ),
              const SizedBox(width: kPaddingMedium),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      profile.name.isNotEmpty ? profile.name : profile.displayName.asHandle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: typography.styleHeroMedium.copyWith(color: textColor),
                    ),
                    if (shouldDisplayProfileId) ...<Widget>[
                      SelectableText(
                        profile.flMeta?.id ?? '',
                        style: typography.styleSubtext.copyWith(color: textColor.withOpacity(metadataOpacity)),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: kPaddingSmall),
          if (profile.isOrganisation && profile.isLocationAvailable)
            // display the location when there is one to show
            Expanded(
              child: Text(
                profile.formattedLocation,
                style: typography.styleButtonRegular.copyWith(color: textColor.withOpacity(metadataOpacity)),
              ),
            ),
          Flexible(
            child: Wrap(
              spacing: kPaddingSmall,
              runSpacing: kPaddingNone,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
