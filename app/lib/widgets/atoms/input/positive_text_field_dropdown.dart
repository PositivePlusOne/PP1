// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/number_extensions.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../../providers/system/design_controller.dart';

class PositiveTextFieldDropdown<T> extends ConsumerStatefulWidget {
  const PositiveTextFieldDropdown({
    required this.values,
    required this.initialValue,
    required this.onValueChanged,
    this.valueStringBuilder,
    this.placeholderStringBuilder,
    this.isEnabled = true,
    super.key,
  });

  final List<T> values;
  final T initialValue;

  final String Function(dynamic value)? valueStringBuilder;
  final String Function(dynamic value)? placeholderStringBuilder;
  final void Function(dynamic value) onValueChanged;

  final bool isEnabled;

  static const EdgeInsets kDropdownPaddingRegular = EdgeInsets.only(left: 30.0, right: 5.0, top: 5.0, bottom: 5.0);

  @override
  PositiveTextFieldDropdownState<T> createState() => PositiveTextFieldDropdownState<T>();
}

class PositiveTextFieldDropdownState<T> extends ConsumerState<PositiveTextFieldDropdown> {
  late T currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
  }

  Future<void> onWidgetSelected(DesignTypographyModel typography) async {
    await showModalBottomSheet<T>(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: widget.values.length,
          itemBuilder: (context, index) {
            final T value = widget.values[index];
            return ListTile(
              title: Text(
                widget.valueStringBuilder?.call(value) ?? value.toString(),
                style: typography.styleButtonRegular,
              ),
              onTap: () => onValueSelected(value),
            );
          },
        );
      },
    );
  }

  void onValueSelected(T value) {
    if (!mounted) {
      return;
    }

    widget.onValueChanged(value);

    setState(() => currentValue = value);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    return PositiveTapBehaviour(
      onTap: () => onWidgetSelected(typography),
      isEnabled: widget.isEnabled,
      child: Container(
        padding: PositiveTextFieldDropdown.kDropdownPaddingRegular,
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(PositiveButton.kButtonBorderRadiusRegular),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                widget.placeholderStringBuilder?.call(currentValue) ?? currentValue.toString(),
                style: typography.styleButtonRegular.copyWith(color: colors.black),
              ),
            ),
            kPaddingLarge.asHorizontalBox,
            Container(
              padding: PositiveButton.kIconPaddingMedium,
              decoration: BoxDecoration(
                color: colors.black,
                borderRadius: BorderRadius.circular(PositiveButton.kButtonIconRadiusRegular),
              ),
              child: Icon(
                UniconsLine.angle_down,
                size: PositiveButton.kButtonIconRadiusRegular,
                color: colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
