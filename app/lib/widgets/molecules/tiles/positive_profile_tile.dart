// Flutter imports:
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
    for (final MapEntry<String, String> entry in metadata.entries) {
      final Widget child = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '${entry.key}:',
            style: typography.styleButtonRegular.copyWith(color: textColor.withOpacity(metadataOpacity)),
          ),
          const SizedBox(width: kPaddingExtraSmall),
          Text(
            entry.value,
            style: typography.styleButtonBold.copyWith(color: textColor),
          ),
        ],
      );

      children.add(child);
    }

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
                child: Text(
                  profile.name.isNotEmpty ? profile.name : profile.displayName.asHandle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: typography.styleHeroMedium.copyWith(color: textColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: kPaddingSmall),
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
