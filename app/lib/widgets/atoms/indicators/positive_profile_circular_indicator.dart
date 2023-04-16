// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';
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
    required this.userProfile,
    this.size = kIconLarge,
    this.icon,
    super.key,
  });

  final UserProfile userProfile;
  final double size;
  final IconData? icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final Color actualColor = userProfile.accentColor.toSafeColorFromHex(defaultColor: colors.teal);

    return PositiveCircularIndicator(
      ringColor: actualColor,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: userProfile.profileImage,
        placeholder: (context, url) => Align(
          alignment: Alignment.center,
          child: PositiveLoadingIndicator(
            width: kIconSmall,
            color: actualColor.complimentTextColor,
          ),
        ),
        errorWidget: (context, url, error) => Icon(
          UniconsLine.exclamation,
          color: actualColor.complimentTextColor,
          size: kIconSmall,
        ),
      ),
    );
  }
}
