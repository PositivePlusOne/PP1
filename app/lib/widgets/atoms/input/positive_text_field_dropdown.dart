// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';

class PositiveTextFieldDropdown<T> extends ConsumerStatefulWidget implements PreferredSizeWidget {
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

  Size get preferredItemSize => const Size(29.0, 17.0);

  Size get preferredIconSize => const Size(24.0, 24.0);

  @override
  Size get preferredSize => const Size(53.0, 40.0);

  @override
  PositiveTextFieldDropdownState<T> createState() => PositiveTextFieldDropdownState();
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

    return GestureDetector(
      onTap: () => onWidgetSelected(typography),
      child: SizedBox(
        height: widget.preferredSize.height,
        width: widget.preferredSize.width,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: widget.preferredItemSize.width,
              height: widget.preferredItemSize.height,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.placeholderStringBuilder?.call(currentValue) ?? currentValue.toString(),
                  style: typography.styleButtonRegular.copyWith(color: colors.black),
                ),
              ),
            ),
            SizedBox(
              width: widget.preferredIconSize.width,
              height: widget.preferredIconSize.height,
              child: Icon(
                UniconsLine.angle_down,
                color: colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
