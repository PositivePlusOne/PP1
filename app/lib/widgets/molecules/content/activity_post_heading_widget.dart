// Flutter imports:
import 'package:app/providers/user/user_controller.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/buttons/positive_button.dart';

class ActivityPostHeadingWidget extends ConsumerWidget {
  const ActivityPostHeadingWidget({
    required this.activity,
    required this.publisher,
    required this.onOptions,
    super.key,
  });

  final Activity activity;
  final Profile? publisher;
  final Function onOptions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typeography = ref.watch(designControllerProvider.select((value) => value.typography));
    final UserController userController = ref.read(userControllerProvider.notifier);
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    final Color accentColor = publisher!.accentColor.toColorFromHex();
    final Color complementaryColor = accentColor.complimentTextColor;

    String displayName = 'Unknown';
    String createdDate = "";

    if (publisher == null) {
      return const SizedBox();
    }

    if (publisher!.displayName.isNotEmpty) {
      displayName = "@${publisher!.displayName}";
    }

    if (activity.flMeta != null && activity.flMeta!.createdDate != null && activity.flMeta!.updatedDate != null) {
      createdDate = activity.flMeta!.createdDate!.asDateDifference(context);
      if (activity.flMeta!.updatedDate!.isNotEmpty && activity.flMeta!.createdDate! != activity.flMeta!.updatedDate!) createdDate = createdDate + localisations.post_last_edited;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingSmallMedium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PositiveProfileCircularIndicator(profile: publisher),
          const SizedBox(width: kPaddingSmall),
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        displayName,
                        style: typeography.styleTitle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: kPaddingSmall),
                    Container(
                      width: kIconSmall,
                      height: kIconSmall,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                        color: accentColor,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        UniconsLine.check,
                        size: kIconExtraSmall,
                        color: complementaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kPaddingExtraSmall),
                Text(
                  createdDate,
                  style: typeography.styleSubtext.copyWith(color: colours.colorGray3),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (userController.currentUser!.uid == publisher!.flMeta!.id)
            PositiveButton.appBarIcon(
              colors: colours,
              icon: UniconsLine.ellipsis_h,
              style: PositiveButtonStyle.text,
              size: PositiveButtonSize.medium,
              onTapped: () => onOptions(context),
            ),
        ],
      ),
    );
  }
}
