// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_checkbox.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../atoms/buttons/enumerations/positive_checkbox_style.dart';

class DisplayInApp extends ConsumerWidget {
  final bool isChecked;
  final void Function() onTapped;

  const DisplayInApp({
    super.key,
    required this.isChecked,
    required this.onTapped,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.watch(
      designControllerProvider.select((value) => value.colors),
    );
    final locale = AppLocalizations.of(context)!;

    return PositiveCheckbox(
      colors: colors,
      onTapped: onTapped,
      iconBackground: isChecked ? colors.green : Colors.transparent,
      style: PositiveCheckboxStyle.small,
      icon: Icon(
        isChecked ? UniconsSolid.check : UniconsLine.eye_slash,
        size: PositiveCheckbox.kCheckboxIconRadiusSmall,
        color: colors.black,
      ),
      label: isChecked
          ? locale.molecule_display_in_app_display
          : locale.molecule_display_in_app_no_display,
      isChecked: isChecked,
    );
  }
}
