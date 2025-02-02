// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/helpers/profile_helpers.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_selectable_indicator.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/organisms/profile/dialogs/profile_modal_dialog.dart';
import '../../../dtos/database/profile/profile.dart';
import '../../../providers/system/design_controller.dart';

enum PositiveProfileListTileType {
  view,
  selectable,
}

class PositiveProfileListTile extends ConsumerWidget {
  const PositiveProfileListTile({
    required this.senderProfile,
    required this.targetProfile,
    required this.relationship,
    this.isEnabled = true,
    this.isDense = false,
    this.isSelected = false,
    this.type = PositiveProfileListTileType.view,
    this.analyticProperties = const <String, Object?>{},
    this.onSelected,
    this.profileDescriptionBuilder,
    this.brightness = Brightness.light,
    super.key,
  });

  final Profile? senderProfile;
  final Profile? targetProfile;
  final Relationship? relationship;

  final bool isEnabled;
  final bool isDense;

  final PositiveProfileListTileType type;
  final Map<String, Object?> analyticProperties;

  final bool isSelected;
  final VoidCallback? onSelected;

  final Brightness brightness;

  final String Function(Profile? profile)? profileDescriptionBuilder;

  static const double kProfileTileHeight = 72.0;
  static const double kProfileTileDenseHeight = 42.0;
  static const double kProfileTileBorderRadius = 40.0;

  Future<void> onOptionsTapped(BuildContext context) async {
    final logger = providerContainer.read(loggerProvider);
    final String currentProfileUid = senderProfile?.flMeta?.id ?? '';
    final String targetProfileUid = targetProfile?.flMeta?.id ?? '';

    logger.d('User profile modal requested: $currentProfileUid');
    if (currentProfileUid.isEmpty) {
      logger.w('User profile modal requested with empty uid');
      return;
    }

    await PositiveDialog.show(
      context: context,
      useSafeArea: false,
      child: ProfileModalDialog(
        targetProfileId: targetProfileUid,
        currentProfileId: currentProfileUid,
      ),
    );
  }

  Future<void> onListTileSelected(BuildContext context, Map<String, Object?> analyticProperties) async {
    if (targetProfile == null) {
      return;
    }

    if (type == PositiveProfileListTileType.view) {
      final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
      await profileController.viewProfile(targetProfile!, analyticProperties);
      return;
    }

    if (onSelected != null) {
      onSelected!();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final String profileDescription = profileDescriptionBuilder?.call(targetProfile!) ?? '';
    final bool isLight = brightness == Brightness.light;

    return PositiveTapBehaviour(
      onTap: (context) => onListTileSelected(context, analyticProperties),
      isEnabled: isEnabled,
      child: Container(
        constraints: BoxConstraints(
          minHeight: isDense ? kProfileTileDenseHeight : kProfileTileHeight,
          maxHeight: isDense ? kProfileTileDenseHeight : kProfileTileHeight,
        ),
        decoration: BoxDecoration(
          color: isLight ? colors.white : colors.colorGray1,
          borderRadius: BorderRadius.circular(kProfileTileBorderRadius),
        ),
        child: Row(
          children: <Widget>[
            const SizedBox(width: kPaddingSmall),
            PositiveProfileCircularIndicator(
              profile: targetProfile,
              size: isDense ? kIconMediumLarge : kIconHuge,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(kPaddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      getSafeDisplayNameFromProfile(targetProfile),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: typography.styleTitle.copyWith(color: colors.colorGray7),
                    ),
                    if (profileDescription.isNotEmpty) ...<Widget>[
                      Text(
                        profileDescription,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: typography.styleSubtext.copyWith(color: colors.colorGray3),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (!isDense) ...<Widget>[
              const SizedBox(width: kPaddingSmall),
              buildAction(context),
              const SizedBox(width: kPaddingSmall),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildAction(BuildContext context) {
    return switch (type) {
      PositiveProfileListTileType.view => buildViewAction(context),
      PositiveProfileListTileType.selectable => buildSelectableAction(context),
    };
  }

  Widget buildViewAction(BuildContext context) {
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));

    // If the two profiles match, we don't want to show the options button
    if (senderProfile?.flMeta?.id == targetProfile?.flMeta?.id) {
      return const SizedBox.shrink();
    }

    return PositiveButton(
      colors: colors,
      primaryColor: colors.colorGray7,
      icon: UniconsSolid.ellipsis_h,
      layout: PositiveButtonLayout.iconOnly,
      style: PositiveButtonStyle.text,
      onTapped: () => onOptionsTapped(context),
      isDisabled: !isEnabled,
    );
  }

  Widget buildSelectableAction(BuildContext context) {
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
    return Align(
      alignment: Alignment.centerRight,
      child: PositiveSelectableIndicator(
        backgroundColor: colors.white,
        isSelected: isSelected,
      ),
    );
  }
}
