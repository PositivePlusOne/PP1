// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/common/fl_meta.dart';
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
    required this.flMetaData,
    required this.publisher,
    required this.onOptions,
    super.key,
  });

  final FlMeta? flMetaData;
  final Profile? publisher;
  final Function onOptions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typeography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    final Color accentColor = publisher?.accentColor.toColorFromHex() ?? colours.teal;
    final Color complementaryColor = accentColor.complimentTextColor;

    String displayName = localisations.shared_placeholders_empty_display_name;
    String postDateTooltip = "";

    if (publisher == null) {
      return const SizedBox();
    }

    if (publisher!.displayName.isNotEmpty) {
      displayName = "@${publisher!.displayName}";
    }

    if (flMetaData != null && flMetaData!.createdDate != null) {
      postDateTooltip = flMetaData!.createdDate!.asDateDifference(context);
      if (flMetaData!.lastModifiedDate != null && flMetaData!.lastModifiedDate!.isNotEmpty && flMetaData!.createdDate! != flMetaData!.lastModifiedDate!) {
        postDateTooltip = '${flMetaData!.createdDate!.asDateDifference(context)} ${localisations.shared_post_tooltips_edited}';
      }
    }

    return Material(
      type: MaterialType.canvas,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
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
                  const SizedBox(height: kPaddingThin),
                  Text(
                    postDateTooltip,
                    style: typeography.styleSubtext.copyWith(color: colours.colorGray3),
                  ),
                ],
              ),
            ),
            // if (userController.currentUser!.uid == publisher!.flMeta!.id)
            PositiveButton.appBarIcon(
              colors: colours,
              icon: UniconsLine.ellipsis_h,
              style: PositiveButtonStyle.text,
              size: PositiveButtonSize.medium,
              onTapped: () => onOptions(context),
            ),
          ],
        ),
      ),
    );
  }
}
