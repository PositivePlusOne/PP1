// Flutter imports:
import 'package:app/constants/design_constants.dart';
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
    this.size = kIconLarge,
    super.key,
  });

  final UserProfile userProfile;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    // TODO(ryan): Update component to use profiles favourite colour over the default teal

    return Container(
      height: size,
      width: size,
      padding: const EdgeInsets.all(kPaddingThin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadiusHuge),
        border: Border.all(
          color: colors.teal,
          width: kBorderThicknessSmall,
        ),
      ),
      child: Image.memory(kTransparentImage),
    );
  }
}
