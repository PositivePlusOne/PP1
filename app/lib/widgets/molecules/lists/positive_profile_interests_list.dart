// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/user/user_profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/content/interests_controller.dart';
import '../../../providers/system/design_controller.dart';

class PositiveProfileInterestsList extends ConsumerWidget {
  const PositiveProfileInterestsList({
    required this.userProfile,
    super.key,
  });

  final UserProfile userProfile;

  Widget buildInterest({
    required DesignColorsModel colors,
    required DesignTypographyModel typography,
    required String interest,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall, vertical: kPaddingExtraSmall),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(kBorderRadiusHuge),
      ),
      child: Text(
        interest,
        style: typography.styleSubtext.copyWith(color: colors.colorGray7),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final InterestsControllerState interestsControllerState = ref.watch(interestsControllerProvider);

    final List<String> interests = [];
    for (final String interest in userProfile.interests) {
      if (interestsControllerState.interests.containsKey(interest)) {
        interests.add(interestsControllerState.interests[interest]!);
      } else {
        interests.add(interest);
      }
    }

    return Wrap(
        spacing: kPaddingSmall,
        runSpacing: kPaddingExtraSmall,
        children: interests
            .map((String interest) => buildInterest(
                  colors: ref.read(designControllerProvider.select((value) => value.colors)),
                  typography: ref.read(designControllerProvider.select((value) => value.typography)),
                  interest: interest,
                ))
            .toList());
  }
}
