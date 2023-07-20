// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_circular_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
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

  //* This is used to override the image path for the profile image, for example when the user is uploading a new image
  final String imageOverridePath;

  String? getValidImageUrlFromMedia() {
    final Media? profileImage = profile?.profileImage;
    String? url = profileImage?.url;

    final bool hasMediumThumbnail = profileImage?.thumbnails.any((element) => element.type == const ThumbnailType.medium()) ?? false;
    final bool hasSmallThumbnail = profileImage?.thumbnails.any((element) => element.type == const ThumbnailType.small()) ?? false;

    if (hasSmallThumbnail) {
      url = profileImage?.thumbnails.firstWhere((element) => element.type == const ThumbnailType.small()).url;
    } else if (hasMediumThumbnail) {
      url = profileImage?.thumbnails.firstWhere((element) => element.type == const ThumbnailType.medium()).url;
    } else if (profileImage?.thumbnails.isNotEmpty ?? false) {
      url = profileImage?.thumbnails.first.url;
    }

    return url;
  }

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

    final String profileImageUrl = getValidImageUrlFromMedia() ?? '';

    final bool hasOverrideImage = imageOverridePath.isNotEmpty;
    final bool hasValidUri = profileImageUrl.isNotEmpty;
    final bool hasValidImage = profileImageUrl.isNotEmpty || imageOverridePath.isNotEmpty;

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
        if (!hasOverrideImage && hasValidUri) ...<Widget>[
          Positioned.fill(
            child: FastCachedImage(
              fit: BoxFit.cover,
              url: profileImageUrl,
              gaplessPlayback: true,
              fadeInDuration: kAnimationDurationInstant,
              cacheHeight: kIconHuge.toInt(),
              cacheWidth: kIconHuge.toInt(),
              loadingBuilder: (context, url) => Align(
                alignment: Alignment.center,
                child: PositiveLoadingIndicator(
                  width: kIconSmall,
                  color: actualColor.complimentTextColor,
                ),
              ),
              errorBuilder: (_, __, ___) => errorWidget,
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
      onTap: () => _handleTap(ref),
      isEnabled: isEnabled,
      child: PositiveCircularIndicator(
        ringColor: actualColor,
        borderThickness: borderThickness,
        size: size,
        child: hasValidImage ? child : errorWidget,
      ),
    );
  }

  void _handleTap(WidgetRef ref) {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);

    // Check if we are on the profile page
    if (appRouter.current.name == ProfileRoute.name) {
      return;
    }

    if (onTap == null) {
      profileController.viewProfile(profile ?? Profile.empty());
    } else {
      onTap?.call();
    }
  }
}
