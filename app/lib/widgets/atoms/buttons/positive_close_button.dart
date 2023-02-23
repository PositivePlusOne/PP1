// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import '../../../providers/system/design_controller.dart';
import 'enumerations/positive_button_layout.dart';
import 'enumerations/positive_button_size.dart';
import 'enumerations/positive_button_style.dart';

class PositiveCloseButton extends ConsumerWidget {
  const PositiveCloseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppRouter appRouter = ref.watch(appRouterProvider);
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return PositiveButton(
      colors: colors,
      onTapped: () async => appRouter.removeLast(),
      style: PositiveButtonStyle.primary,
      icon: UniconsLine.multiply,
      size: PositiveButtonSize.medium,
      isActive: true,
      layout: PositiveButtonLayout.iconOnly,
      tooltip: localizations.shared_actions_close,
      label: '',
    );
  }
}
