// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import '../../../providers/system/design_controller.dart';
import 'enumerations/positive_button_layout.dart';
import 'enumerations/positive_button_size.dart';
import 'enumerations/positive_button_style.dart';

class PositiveBackButton extends ConsumerWidget {
  const PositiveBackButton({
    this.onBackSelected,
    this.isDisabled = false,
    this.label,
    super.key,
  });

  final VoidCallback? onBackSelected;
  final bool isDisabled;
  final String? label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppRouter appRouter = ref.watch(appRouterProvider);
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Align(
      alignment: Alignment.centerLeft,
      child: IntrinsicWidth(
        child: PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          isDisabled: isDisabled,
          onTapped: onBackSelected ?? () => appRouter.removeLast(),
          label: label ?? localizations.shared_actions_back,
          style: PositiveButtonStyle.text,
          layout: PositiveButtonLayout.textOnly,
          size: PositiveButtonSize.small,
          borderWidth: PositiveButton.kButtonBorderWidthHovered,
          padding: PositiveButton.kButtonPaddingTiny,
        ),
      ),
    );
  }
}
