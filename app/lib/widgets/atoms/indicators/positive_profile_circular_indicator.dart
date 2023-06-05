// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_circular_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../../providers/system/design_controller.dart';

class PositiveProfileCircularIndicator extends ConsumerWidget {
  const PositiveProfileCircularIndicator({
    this.profile,
    this.onTap,
    this.isEnabled = false,
    this.size = kIconLarge,
    this.borderThickness = kBorderThicknessSmall,
    this.icon,
    this.isApplyingOnAccentColor = false,
    this.ringColorOverride,
    super.key,
  });

  final Profile? profile;
  final double size;
  final double borderThickness;

  final VoidCallback? onTap;
  final bool isEnabled;

  final IconData? icon;
  final bool isApplyingOnAccentColor;

  final Color? ringColorOverride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));

    Color actualColor = profile?.accentColor.toSafeColorFromHex(defaultColor: colours.colorGray2) ?? colours.colorGray2;
    if (isApplyingOnAccentColor) {
      actualColor = actualColor.complimentTextColor;
    }

    if (ringColorOverride != null) {
      actualColor = ringColorOverride!;
    }

    final Icon errorWidget = Icon(
      UniconsLine.user,
      color: colours.white,
      size: kIconSmall,
    );

    final Widget child = Stack(
      children: <Widget>[
        Positioned.fill(
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: profile?.profileImage ?? '',
            placeholder: (context, url) => Align(
              alignment: Alignment.center,
              child: PositiveLoadingIndicator(
                width: kIconSmall,
                color: actualColor.complimentTextColor,
              ),
            ),
            errorWidget: (_, __, ___) => errorWidget,
          ),
        ),
        Positioned.fill(
          child: Icon(
            size: kIconSmall,
            icon,
            color: colours.white,
          ),
        )
      ],
    );

    // Check profile.profileImage is a valid URL
    final Uri? uri = Uri.tryParse(profile?.profileImage ?? '');

    return PositiveTapBehaviour(
      onTap: () => _handleTap(ref),
      isEnabled: !isEnabled,
      child: PositiveCircularIndicator(
        ringColor: actualColor,
        borderThickness: borderThickness,
        size: size,
        child: uri != null && uri.isAbsolute ? child : errorWidget,
      ),
    );
  }

  void _handleTap(WidgetRef ref) {
    if (onTap == null) {
      ref.read(profileControllerProvider.notifier).viewProfile(profile ?? Profile.empty());
    } else {
      onTap?.call();
    }
  }
}
