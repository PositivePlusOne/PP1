// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/widgets/atoms/imagery/positive_media_image.dart';
import 'package:app/widgets/atoms/indicators/positive_circular_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../../dtos/database/common/media.dart';
import '../../../providers/system/design_controller.dart';

class PositiveProfileCircularIndicator extends ConsumerWidget {
  const PositiveProfileCircularIndicator({
    this.profile,
    this.onTap,
    this.isEnabled = true,
    this.size = kIconLarge,
    this.borderThickness = kBorderThicknessSmall,
    this.icon,
    this.isApplyingOnAccentColor = false,
    this.ringColorOverride,
    this.imageOverridePath = '',
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

  final String imageOverridePath;

  bool get hasOverrideImage => imageOverridePath.isNotEmpty;

  static const int kTargetSize = 100;

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

    final Media? media = profile?.profileImage;

    final Widget child = Stack(
      children: <Widget>[
        if (hasOverrideImage) ...<Widget>[
          Positioned.fill(
            child: Image.file(
              File(imageOverridePath),
              fit: BoxFit.cover,
            ),
          ),
        ],
        if (!hasOverrideImage && media != null) ...<Widget>[
          Positioned.fill(
            child: PositiveMediaImage(
              fit: BoxFit.cover,
              media: media,
              isEnabled: false,
              placeholderBuilder: (context) => Align(
                alignment: Alignment.center,
                child: PositiveLoadingIndicator(
                  width: kIconSmall,
                  color: actualColor.complimentTextColor,
                ),
              ),
              errorBuilder: (_) => errorWidget,
            ),
          ),
        ],
        Positioned.fill(
          child: Icon(
            size: kIconSmall,
            icon,
            color: colours.white,
          ),
        )
      ],
    );

    return PositiveTapBehaviour(
      onTap: (context) => _handleTap(context, ref),
      isEnabled: isEnabled,
      child: PositiveCircularIndicator(
        ringColor: actualColor,
        borderThickness: borderThickness,
        size: size,
        child: child,
        // child: hasValidImage ? child : errorWidget,
      ),
    );
  }

  void _handleTap(BuildContext context, WidgetRef ref) {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);

    if (onTap != null) {
      onTap!();
      return;
    }

    // Check if we are on the profile page
    if (appRouter.current.name == ProfileRoute.name) {
      return;
    }

    profileController.viewProfile(profile ?? Profile.empty());
  }
}
