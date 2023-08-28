// Dart imports:
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/helpers/image_helpers.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/imagery/positive_media_image.dart';
import 'package:app/widgets/atoms/indicators/positive_circular_indicator.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../../dtos/database/common/media.dart';
import '../../../providers/system/design_controller.dart';

class PositiveProfileCircularIndicator extends ConsumerStatefulWidget {
  const PositiveProfileCircularIndicator({
    this.profile,
    this.onTap,
    this.isEnabled = true,
    this.size = kIconLarge,
    this.borderThickness = kBorderThicknessSmall,
    this.borderPadding = kPaddingSmall,
    this.icon,
    this.complimentRingColorForBackground = false,
    this.backgroundColorOverride,
    this.ringColorOverride,
    this.imageOverridePath = '',
    this.fit,
    super.key,
  });

  final Profile? profile;
  final double size;
  final double borderThickness;
  final double borderPadding;

  final VoidCallback? onTap;
  final bool isEnabled;

  final IconData? icon;
  final bool complimentRingColorForBackground;

  final Color? backgroundColorOverride;
  final Color? ringColorOverride;

  final String imageOverridePath;

  final BoxFit? fit;

  bool get hasOverrideImage => imageOverridePath.isNotEmpty;

  static const int kTargetSize = 100;

  @override
  ConsumerState<PositiveProfileCircularIndicator> createState() => _PositiveProfileCircularIndicatorState();
}

class _PositiveProfileCircularIndicatorState extends ConsumerState<PositiveProfileCircularIndicator> {
  Color ringColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    loadInitialRingColor();
  }

  void loadInitialRingColor() {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    Color actualColor = widget.profile?.accentColor.toSafeColorFromHex(defaultColor: colours.colorGray2) ?? colours.colorGray2;
    if (widget.ringColorOverride != null) {
      actualColor = widget.ringColorOverride!;
    }

    ringColor = actualColor;
  }

  Future<void> onBytesLoaded(String mimeType, Uint8List bytes) async {
    final Logger logger = providerContainer.read(loggerProvider);
    if (widget.ringColorOverride != null) {
      return;
    }

    if (widget.profile?.accentColor.isNotEmpty ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.profile == null) {
          return;
        }

        ringColor = widget.profile!.accentColor.toSafeColorFromHex(defaultColor: Colors.transparent);
        setStateIfMounted();
      });

      return;
    }

    final Color? dominantColor = getMostCommonColor(bytes);
    if (dominantColor == null) {
      logger.w('Could not get dominant color for ${widget.imageOverridePath}');
      return;
    }

    logger.d('Dominant color for ${widget.imageOverridePath} is $dominantColor');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => ringColor = dominantColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));

    Color actualRingColor = ringColor;
    if (widget.complimentRingColorForBackground) {
      actualRingColor = actualRingColor.complimentTextColor;
    }

    final Media? media = widget.hasOverrideImage ? Media.fromImageUrl(widget.imageOverridePath) : widget.profile?.profileImage;
    final Widget child = Stack(
      children: <Widget>[
        if (media != null) ...<Widget>[
          Positioned.fill(
            child: PositiveMediaImage(
              media: media,
              isEnabled: false,
              fit: widget.fit ?? BoxFit.cover,
              backgroundColor: widget.backgroundColorOverride ?? Colors.transparent,
              placeholderBuilder: (_) => const SizedBox.shrink(),
              errorBuilder: (_) => const SizedBox.shrink(),
              onBytesLoaded: onBytesLoaded,
            ),
          ),
        ],
        if (widget.icon != null) ...<Widget>[
          Positioned.fill(
            child: Icon(
              size: kIconSmall,
              widget.icon,
              color: colours.white,
            ),
          ),
        ],
      ],
    );

    return PositiveTapBehaviour(
      onTap: (context) => _handleTap(context, ref),
      isEnabled: widget.isEnabled,
      child: PositiveCircularIndicator(
        ringColor: actualRingColor,
        borderThickness: widget.borderThickness,
        size: widget.size,
        child: child,
        // child: hasValidImage ? child : errorWidget,
      ),
    );
  }

  void _handleTap(BuildContext context, WidgetRef ref) {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);

    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }

    // Check if we are on the profile page
    if (appRouter.current.name == ProfileRoute.name) {
      return;
    }

    profileController.viewProfile(widget.profile ?? Profile.empty());
  }
}
