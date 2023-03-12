// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';

// Project imports:
import 'package:app/dtos/database/user/user_profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';

class PositiveProfileImageIndicator extends ConsumerWidget {
  const PositiveProfileImageIndicator({
    required this.userProfile,
    super.key,
  });

  final UserProfile userProfile;

  static const double kPadding = 1.0;
  static const double kBorderRadius = 40.0;
  static const double kBorderWidth = 1.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    // TODO(ryan): Update component to use profiles favourite colour over the default teal

    return Container(
      height: kBorderRadius,
      width: kBorderRadius,
      padding: const EdgeInsets.all(kPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(
          color: colors.teal,
          width: kBorderWidth,
        ),
      ),
      child: Image.memory(kTransparentImage),
    );
  }
}
