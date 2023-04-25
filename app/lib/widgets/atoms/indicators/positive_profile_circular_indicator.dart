// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/user/user_profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/widgets/atoms/indicators/positive_circular_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import '../../../providers/system/design_controller.dart';

class PositiveProfileCircularIndicator extends ConsumerWidget {
  const PositiveProfileCircularIndicator({
    this.userProfile,
    this.onTap,
    this.size = kIconLarge,
    this.borderThickness = kBorderThicknessSmall,
    this.icon,
    this.isApplyingOnAccentColor = false,
    this.ringColorOverride,
    super.key,
  });

  final UserProfile? userProfile;
  final double size;
  final double borderThickness;

  final VoidCallback? onTap;

  final IconData? icon;
  final bool isApplyingOnAccentColor;

  final Color? ringColorOverride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    Color actualColor = userProfile?.accentColor.toSafeColorFromHex(defaultColor: colors.teal) ?? colors.teal;
    if (isApplyingOnAccentColor) {
      actualColor = actualColor.complimentTextColor;
    }

    if (ringColorOverride != null) {
      actualColor = ringColorOverride!;
    }

    final Icon errorWidget = Icon(
      UniconsLine.exclamation,
      color: actualColor.complimentTextColor,
      size: kIconSmall,
    );

    final Widget child = Stack(
      children: <Widget>[
        Positioned.fill(
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: userProfile?.profileImage ?? '',
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
            color: colors.white,
          ),
        )
      ],
    );

    // Check userProfile.profileImage is a valid URL
    final Uri? uri = Uri.tryParse(userProfile?.profileImage ?? '');

    return GestureDetector(
      onTapDown: (_) => onTap,
      child: PositiveCircularIndicator(
        ringColor: actualColor,
        borderThickness: borderThickness,
        size: size,
        child: uri != null && uri.isAbsolute ? child : errorWidget,
      ),
    );
  }
}
