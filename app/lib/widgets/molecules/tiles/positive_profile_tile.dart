// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
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
    super.key,
  });

  final Brightness brightness;
  final double metadataOpacity;

  final Profile profile;
  final Map<String, String> metadata;
  final EdgeInsets padding;

  static const double kTaglineAreaHeight = 60.0;

  @override
  Size get preferredSize => const Size.fromHeight(kPaddingSmall + kIconHeader + kTaglineAreaHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final Color textColor = brightness == Brightness.light ? colors.black : colors.white;
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final String tagline = profile.getTagline(localizations);

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
          SizedBox(
            height: kIconHeader,
            width: double.infinity,
            child: Row(
              children: <Widget>[
                PositiveProfileCircularIndicator(
                  profile: profile,
                  size: kIconHeader,
                  isApplyingOnAccentColor: true,
                ),
                const SizedBox(width: kPaddingMedium),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          profile.displayName.asHandle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: typography.styleSuperSize.copyWith(color: textColor),
                        ),
                      ),
                      if (profile.name.isNotEmpty) ...<Widget>[
                        Text(
                          profile.name,
                          style: typography.styleSubtitle.copyWith(color: textColor),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: kPaddingSmall),
          SizedBox(
            height: kTaglineAreaHeight,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  tagline,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: typography.styleSubtitle.copyWith(color: textColor),
                ),
                Wrap(
                  spacing: kPaddingSmall,
                  runSpacing: kPaddingNone,
                  children: children,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
