// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/input/positive_text_field_prefix_container.dart';

class PositiveTextField extends StatefulHookConsumerWidget {
  const PositiveTextField({
    super.key,
    this.initialText = '',
    this.labelText = '',
    this.tintColor = Colors.blue,
    this.onTextChanged,
    this.onFocusedChanged,
    this.textInputType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.isEnabled = true,
  });

  final String initialText;
  final String labelText;

  final Function(String str)? onTextChanged;
  final Function(bool isFocused)? onFocusedChanged;

  final Color tintColor;

  final TextInputType textInputType;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final bool obscureText;
  final bool isEnabled;

  static const double kBorderWidthFocused = 1.0;
  static const double kBorderWidth = 0.0;
  static const double kBorderRadius = 100.0;
  static const double kContentPaddingHorizontal = 30.0;
  static const double kContentPaddingVertical = 12.0;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PositiveTextFieldState();
}

class PositiveTextFieldState extends ConsumerState<PositiveTextField> {
  late final FocusNode textFocusNode;
  late final TextEditingController textEditingController;

  String lastKnownText = '';

  bool get isFocused => _isFocused;

  bool _isFocused = false;
  set isFocused(bool value) {
    if (_isFocused != value) {
      setState(() {
        _isFocused = value;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupLateVariables();
    setupListeners();
  }

  @override
  void dispose() {
    disposeListeners();
    super.dispose();
  }

  void setupLateVariables() {
    textFocusNode = FocusNode();
    textEditingController = TextEditingController(text: widget.initialText);
    lastKnownText = widget.initialText;
  }

  void setupListeners() {
    textFocusNode.addListener(onFocusChanged);
    textEditingController.addListener(onControllerChanged);
  }

  void disposeListeners() {
    textFocusNode.removeListener(onFocusChanged);
    textEditingController.removeListener(onControllerChanged);
  }

  void onFocusChanged() {
    if (!mounted) {
      return;
    }

    isFocused = textFocusNode.hasFocus;
    if (widget.onFocusedChanged != null) {
      widget.onFocusedChanged!(isFocused);
    }
  }

  void onControllerChanged() {
    if (!mounted) {
      return;
    }

    if (widget.onTextChanged != null && lastKnownText != textEditingController.text) {
      widget.onTextChanged!(textEditingController.text);
    }

    lastKnownText = textEditingController.text;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    final bool hasText = textEditingController.text.isNotEmpty;

    final OutlineInputBorder baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(PositiveTextField.kBorderRadius),
      borderSide: const BorderSide(
        width: PositiveTextField.kBorderWidth,
        style: BorderStyle.none,
        color: Colors.transparent,
      ),
    );

    return TextFormField(
      focusNode: textFocusNode,
      enableSuggestions: true,
      obscureText: widget.obscureText,
      keyboardType: widget.textInputType,
      controller: textEditingController,
      enabled: widget.isEnabled,
      style: typography.styleButtonRegular.copyWith(color: colors.black),
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon != null
            ? PositiveTextFieldPrefixContainer(
                color: hasText || isFocused ? widget.tintColor : colors.colorGray2,
                child: widget.prefixIcon!,
              )
            : null,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
        labelStyle: typography.styleButtonRegular.copyWith(
          color: hasText || isFocused ? widget.tintColor : colors.black,
          fontWeight: isFocused ? FontWeight.w800 : FontWeight.w600,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: PositiveTextField.kContentPaddingVertical,
          horizontal: PositiveTextField.kContentPaddingHorizontal,
        ),
        border: baseBorder,
        disabledBorder: baseBorder,
        errorBorder: baseBorder,
        focusedErrorBorder: baseBorder,
        enabledBorder: baseBorder.copyWith(
          borderSide: BorderSide(
            width: PositiveTextField.kBorderWidthFocused,
            color: hasText ? widget.tintColor : Colors.transparent,
          ),
        ),
        focusedBorder: baseBorder.copyWith(
          borderSide: BorderSide(
            width: PositiveTextField.kBorderWidthFocused,
            color: widget.tintColor,
          ),
        ),
      ),
    );
  }
}
