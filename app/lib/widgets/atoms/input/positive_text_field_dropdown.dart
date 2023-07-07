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
import 'package:app/main.dart';
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

  static Future<T?> showDropdownDialog<T>({
    required BuildContext context,
    String Function(dynamic value)? valueStringBuilder,
    List<T> values = const [],
  }) async {
    final DesignTypographyModel typography = providerContainer.read(designControllerProvider.select((value) => value.typography));

    T? value;
    await showModalBottomSheet<T>(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: values.length,
          itemBuilder: (context, index) {
            final T tVal = values[index];
            return ListTile(
              title: Text(
                valueStringBuilder?.call(tVal) ?? tVal.toString(),
                style: typography.styleButtonRegular,
              ),
              onTap: () => value = tVal,
            );
          },
        );
      },
    );

    return value;
  }

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

  Future<void> onWidgetSelected() async {
    final T? value = await PositiveTextFieldDropdown.showDropdownDialog<T>(
      context: context,
      values: widget.values as List<T>,
      valueStringBuilder: widget.valueStringBuilder,
    );

    if (value == null) {
      return;
    }

    onValueSelected(value);
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
      onTap: onWidgetSelected,
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
            FittedBox(
              fit: BoxFit.scaleDown,
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
