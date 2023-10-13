// Flutter imports:
import 'package:app/extensions/widget_extensions.dart';
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
    this.isEnabled = true,
    this.valueStringBuilder,
    this.placeholderStringBuilder,
    this.borderColour,
    this.backgroundColour,
    this.textStyle,
    this.labelTextStyle,
    this.labelText,
    this.iconColour,
    this.iconBackgroundColour,
    this.valueComparator,
    super.key,
  });

  final List<T> values;
  final T initialValue;

  final String Function(dynamic value)? valueStringBuilder;
  final String Function(dynamic value)? placeholderStringBuilder;
  final void Function(dynamic value) onValueChanged;

  final bool Function(dynamic value, dynamic other)? valueComparator;

  final String? labelText;
  final TextStyle? labelTextStyle;

  final Color? borderColour;
  final Color? backgroundColour;
  final TextStyle? textStyle;
  final Color? iconColour;
  final Color? iconBackgroundColour;

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
                valueStringBuilder?.call(tVal) ?? tVal?.toString() ?? 'null',
                style: typography.styleButtonRegular,
              ),
              onTap: () {
                value = tVal;
                Navigator.of(context).pop();
              },
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

  @override
  void didUpdateWidget(PositiveTextFieldDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.valueComparator != null && !widget.valueComparator!(oldWidget.initialValue, widget.initialValue)) {
      currentValue = widget.initialValue;
      setStateIfMounted();
    } else if (widget.valueComparator == null && oldWidget.initialValue != widget.initialValue) {
      currentValue = widget.initialValue;
      setStateIfMounted();
    }
  }

  Future<void> onWidgetSelected(BuildContext context) async {
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
          color: widget.backgroundColour ?? colors.white,
          border: Border.all(
            color: widget.borderColour ?? colors.transparent,
            width: PositiveButton.kButtonBorderWidth,
          ),
          borderRadius: BorderRadius.circular(PositiveButton.kButtonBorderRadiusRegular),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.labelText != null) ...[
                    Text(
                      widget.labelText!,
                      style: widget.labelTextStyle ?? typography.styleSubtextBold,
                    ),
                  ],
                  Text(
                    widget.placeholderStringBuilder?.call(currentValue) ?? currentValue.toString(),
                    style: widget.textStyle ?? typography.styleButtonRegular.copyWith(color: colors.black),
                  ),
                  const SizedBox(height: kPaddingExtraSmall)
                ],
              ),
            ),
            kPaddingLarge.asHorizontalBox,
            Container(
              padding: PositiveButton.kIconPaddingMedium,
              decoration: BoxDecoration(
                color: widget.iconBackgroundColour ?? colors.black,
                borderRadius: BorderRadius.circular(PositiveButton.kButtonIconRadiusRegular),
              ),
              child: Icon(
                UniconsLine.angle_down,
                size: PositiveButton.kButtonIconRadiusRegular,
                color: widget.iconColour ?? colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
