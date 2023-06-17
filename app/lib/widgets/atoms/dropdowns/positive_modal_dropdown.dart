// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';

class PositiveModalDropdown<T> extends ConsumerWidget {
  const PositiveModalDropdown({
    this.title = '',
    required this.values,
    required this.initialValue,
    this.valueStringBuilder,
    super.key,
  });

  final String title;
  final List<T> values;
  final T? initialValue;
  final String Function(dynamic value)? valueStringBuilder;

  static Future<T?> show<T>(
    BuildContext context, {
    String title = '',
    required List<T> values,
    T? initialValue,
    String Function(dynamic value)? valueStringBuilder,
  }) async {
    return PositiveDialog.show(
      context: context,
      dialog: PositiveModalDropdown(
        title: title,
        initialValue: initialValue,
        values: values,
        valueStringBuilder: valueStringBuilder,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    return PositiveDialog(
      title: title,
      child: SizedBox.fromSize(
        size: kDefaultDatePickerDialogSize,
        child: ListView.separated(
          itemCount: values.length,
          separatorBuilder: (context, index) => const SizedBox(height: kPaddingSmall),
          itemBuilder: (context, index) {
            final T value = values[index];
            return PositiveButton(
              colors: colors,
              onTapped: () => Navigator.of(context).pop(value),
              label: valueStringBuilder?.call(value) ?? value.toString(),
              style: PositiveButtonStyle.ghost,
              size: PositiveButtonSize.large,
            );
          },
        ),
      ),
    );
  }
}
