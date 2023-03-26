// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/enumerations/positive_togglable_state.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/indicators/positive_loading_indicator.dart';

class PositiveVisibilityHint extends ConsumerWidget {
  const PositiveVisibilityHint({
    required this.toggleState,
    super.key,
  });

  final PositiveTogglableState toggleState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final AppLocalizations localizations = AppLocalizations.of(context)!;
    late final Widget toggleIconWidget;
    final String text;

    switch (toggleState) {
      case PositiveTogglableState.loading:
        toggleIconWidget = const PositiveLoadingIndicator();
        text = localizations.shared_actions_updating;
        break;

      case PositiveTogglableState.active:
        toggleIconWidget = Container(
          width: kIconMedium,
          height: kIconMedium,
          decoration: BoxDecoration(
            color: colors.green,
            borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          ),
          child: Icon(
            UniconsLine.check,
            color: colors.black,
            size: kIconSmall,
          ),
        );
        text = localizations.molecule_display_in_app_display;
        break;

      case PositiveTogglableState.alwaysActive:
        toggleIconWidget = SizedBox(
          width: kIconMedium,
          height: kIconMedium,
          child: Icon(
            UniconsLine.eye,
            color: colors.green,
            size: kIconMedium,
          ),
        );
        text = localizations.molecule_display_in_app_always_display;
        break;

      case PositiveTogglableState.inactive:
      default:
        toggleIconWidget = SizedBox(
          width: kIconMedium,
          height: kIconMedium,
          child: Icon(
            UniconsLine.eye_slash,
            color: colors.black,
            size: kIconSmall,
          ),
        );
        text = localizations.molecule_display_in_app_no_display;
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.colorGray3.withOpacity(kOpacityQuarter),
        borderRadius: BorderRadius.circular(kBorderRadiusMedium),
      ),
      padding: const EdgeInsets.all(kPaddingExtraSmall),
      child: Row(
        children: [
          const SizedBox(width: kPaddingExtraSmall),
          toggleIconWidget,
          const SizedBox(width: kPaddingSmall),
          Text(
            text,
            style: typography.styleSubtitle,
          ),
        ],
      ),
    );
  }
}
