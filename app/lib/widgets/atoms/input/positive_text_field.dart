// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/input/positive_text_field_length_indicator.dart';
import 'package:app/widgets/atoms/input/positive_text_field_prefix_container.dart';

class PositiveTextField extends StatefulHookConsumerWidget {
  const PositiveTextField({
    this.initialText = '',
    this.labelText,
    this.hintText,
    this.fillColor,
    this.tintColor = Colors.blue,
    this.onTextChanged,
    this.onTextSubmitted,
    this.onFocusedChanged,
    this.textInputAction = TextInputAction.done,
    this.textInputType = TextInputType.text,
    this.prefixIcon,
    this.label,
    this.suffixIcon,
    this.obscureText = false,
    this.isEnabled = true,
    this.maxLines = 1,
    this.minLines = 1,
    this.onControllerCreated,
    this.maxLength,
    this.maxLengthEnforcement = MaxLengthEnforcement.none,
    super.key,
  });

  final String initialText;
  final String? labelText;
  final Widget? label;
  final String? hintText;
  final int? maxLength;
  final MaxLengthEnforcement maxLengthEnforcement;

  final Function(String str)? onTextChanged;
  final Function(String str)? onTextSubmitted;
  final Function(bool isFocused)? onFocusedChanged;

  final Color tintColor;
  final Color? fillColor;

  final TextInputAction textInputAction;
  final TextInputType textInputType;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final bool obscureText;
  final bool isEnabled;

  final int maxLines;
  final int minLines;

  final void Function(TextEditingController controller)? onControllerCreated;

  static const double kBorderWidthFocused = 1.0;
  static const double kBorderWidth = 0.0;
  static const double kBorderRadius = 25.0;
  static const double kContentPaddingHorizontal = 30.0;
  static const double kContentPaddingVertical = 12.0;
  static const String kObscureTextCharacter = '*';

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

    widget.onControllerCreated?.call(textEditingController);
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

    Widget? labelChild;
    if (widget.label != null) {
      labelChild = widget.label;
    }

    final bool useLengthLabel = widget.labelText != null && widget.maxLengthEnforcement != MaxLengthEnforcement.none;
    if (useLengthLabel) {
      labelChild = PositiveTextFieldLengthIndicator(
        maximumLength: widget.maxLength ?? 0,
        currentLength: textEditingController.text.length,
        focusColor: colors.purple,
        isFocused: isFocused,
        leading: widget.labelText ?? '',
      );
    }

    return TextFormField(
      focusNode: textFocusNode,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      enableSuggestions: true,
      obscureText: widget.obscureText,
      obscuringCharacter: PositiveTextField.kObscureTextCharacter,
      keyboardType: widget.textInputType,
      textInputAction: widget.textInputAction,
      controller: textEditingController,
      enabled: widget.isEnabled,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      cursorColor: colors.black,
      style: typography.styleButtonRegular.copyWith(color: colors.black),
      onFieldSubmitted: (String text) => widget.onTextSubmitted?.call(text),
      decoration: InputDecoration(
        counter: const SizedBox(),
        prefixIcon: widget.prefixIcon != null
            ? PositiveTextFieldPrefixContainer(
                color: hasText || isFocused ? widget.tintColor : colors.colorGray2,
                child: widget.prefixIcon!,
              )
            : null,
        suffixIcon: widget.suffixIcon,
        alignLabelWithHint: true,
        labelText: useLengthLabel ? null : widget.labelText,
        label: labelChild,
        labelStyle: typography.styleButtonRegular.copyWith(
          color: hasText || isFocused ? widget.tintColor : colors.black,
          fontWeight: isFocused ? FontWeight.w800 : FontWeight.w600,
        ),
        hintText: widget.hintText,
        hintStyle: typography.styleButtonRegular.copyWith(
          color: colors.black,
          fontWeight: FontWeight.w600,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: widget.fillColor ?? colors.white,
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
