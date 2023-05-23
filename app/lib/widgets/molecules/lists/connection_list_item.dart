// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/content/connections_controller.dart';
import 'package:app/providers/content/interests_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import '../../../providers/system/design_controller.dart';

class ConnectionListItem extends ConsumerWidget {
  final ConnectedUser connectedUser;
  final bool isSelected;
  final void Function() onTap;
  const ConnectionListItem({Key? key, required this.onTap, this.isSelected = false, required this.connectedUser}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final interests = ref.watch(interestsControllerProvider).interests;
    const double kSelectSize = 24;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(kPaddingSmall),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(kBorderRadiusMassive),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PositiveProfileCircularIndicator(
              profile: Profile(
                accentColor: connectedUser.accentColor ?? "",
                displayName: connectedUser.displayName,
                profileImage: connectedUser.profileImage ?? "",
              ),
            ),
            const SizedBox(width: kPaddingSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "@${connectedUser.displayName}",
                    style: typography.styleTitle,
                  ),
                  Text(extraProfileInfo(interests), style: typography.styleSubtext.copyWith(color: colors.colorGray3)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: kPaddingSmall),
              child: Align(
                alignment: Alignment.center,
                child: isSelected ? const Icon(UniconsSolid.check_circle, size: kSelectSize) : const Icon(UniconsLine.circle, size: kSelectSize),
              ),
            )
          ],
        ),
      ),
    );
  }

  String extraProfileInfo(Map<String, String> interests) {
    List<String> extraInfo = [];
    if (connectedUser.birthday != null) {
      final birthday = DateTime.tryParse(connectedUser.birthday!);
      if (birthday != null) {
        final age = DateTime.now().difference(birthday).inDays ~/ 365;
        extraInfo.add(age.toString());
      }
    }

    if (connectedUser.locationName != null) {
      extraInfo.add(connectedUser.locationName!);
    }

    if (connectedUser.hivStatus != null) {
      extraInfo.add(connectedUser.hivStatus!);
    }

    if (connectedUser.genders != null) {
      extraInfo.add(connectedUser.genders!.join(", "));
    }

    if (connectedUser.interests != null) {
      extraInfo.add(connectedUser.interests!.map((e) => interests[e] ?? "").join(", "));
    }

    return extraInfo.join(", ");
  }
}
