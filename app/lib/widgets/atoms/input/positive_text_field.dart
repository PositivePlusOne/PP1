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

import '../../../constants/design_constants.dart';

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
    this.borderRadius,
    this.textStyle,
    this.labelColor,
    this.lengthIndicatorColor,
    this.labelStyle,
    super.key,
  });

  final String initialText;
  final String? labelText;
  final Widget? label;
  final String? hintText;
  final int? maxLength;
  final MaxLengthEnforcement maxLengthEnforcement;
  final TextStyle? textStyle;
  final Color? labelColor;
  final Color? lengthIndicatorColor;
  final double? borderRadius;
  final TextStyle? labelStyle;

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
    final double borderRadius = widget.borderRadius ?? PositiveTextField.kBorderRadius;
    final Color textColour = widget.textStyle?.color ?? colors.black;
    final TextStyle labelStyle = widget.labelStyle ?? typography.styleButtonRegular;

    final OutlineInputBorder baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(
        width: PositiveTextField.kBorderWidth,
        style: BorderStyle.none,
        color: colors.transparent,
      ),
    );

    final BoxDecoration baseBorderDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        width: PositiveTextField.kBorderWidth,
        style: BorderStyle.none,
        color: colors.transparent,
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
        focusColor: widget.labelColor ?? colors.purple,
        lengthColor: widget.lengthIndicatorColor,
        isFocused: isFocused,
        leading: widget.labelText ?? '',
      );
    }

    return Container(
      constraints: BoxConstraints(minHeight: kCreatePostHeight),
      decoration: textFocusNode.hasFocus
          ? baseBorderDecoration.copyWith(
              color: widget.fillColor ?? colors.white,
              border: Border.all(
                color: widget.tintColor,
                width: PositiveTextField.kBorderWidthFocused,
              ),
            )
          : baseBorderDecoration.copyWith(
              color: widget.fillColor ?? colors.white,
              border: Border.all(width: kPaddingNone),
            ),
      padding: textFocusNode.hasFocus
          ? const EdgeInsets.only(
              top: kPaddingSmall * 0.75,
              bottom: kPaddingSmall * 0.25,
              left: PositiveTextField.kContentPaddingHorizontal,
              right: PositiveTextField.kContentPaddingHorizontal,
            )
          : const EdgeInsets.only(
              top: PositiveTextField.kBorderWidthFocused + kPaddingSmall / 2,
              bottom: PositiveTextField.kBorderWidthFocused + kPaddingSmall / 2,
              left: PositiveTextField.kBorderWidthFocused + PositiveTextField.kContentPaddingHorizontal,
              right: PositiveTextField.kBorderWidthFocused + PositiveTextField.kContentPaddingHorizontal,
            ),
      child: Align(
        alignment: Alignment.center,
        child: TextFormField(
          focusNode: textFocusNode,
          inputFormatters: [
            if (widget.maxLengthEnforcement != MaxLengthEnforcement.none) LengthLimitingTextInputFormatter(widget.maxLength),
          ],
          enableSuggestions: true,
          obscureText: widget.obscureText,
          obscuringCharacter: PositiveTextField.kObscureTextCharacter,
          keyboardType: widget.textInputType,
          textInputAction: widget.textInputAction,
          controller: textEditingController,
          enabled: widget.isEnabled,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          cursorColor: textColour,
          style: widget.textStyle ?? typography.styleButtonRegular.copyWith(color: textColour),
          onFieldSubmitted: (String text) => widget.onTextSubmitted?.call(text),
          decoration: InputDecoration(
            isCollapsed: true,
            isDense: true,
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
            labelStyle: labelStyle.copyWith(
              color: widget.labelColor ?? (hasText || isFocused ? widget.tintColor : textColour),
              fontWeight: isFocused ? FontWeight.w800 : FontWeight.w600,
            ),
            hintText: widget.hintText,
            hintStyle: typography.styleButtonRegular.copyWith(
              color: textColour,
              fontWeight: FontWeight.w600,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            contentPadding: EdgeInsets.only(
              top: textFocusNode.hasFocus ? kPaddingSmall : kPaddingSmall / 2,
              bottom: textFocusNode.hasFocus ? kPaddingNone : kPaddingSmall / 2,
              left: kPaddingNone,
              right: kPaddingNone,
            ),
            border: baseBorder,
            disabledBorder: baseBorder,
            errorBorder: baseBorder,
            focusedErrorBorder: baseBorder,
            enabledBorder: baseBorder.copyWith(
              borderSide: const BorderSide(
                width: PositiveTextField.kBorderWidthFocused,
                color: Colors.transparent,
              ),
            ),
            focusedBorder: baseBorder.copyWith(
              borderSide: BorderSide(
                width: PositiveTextField.kBorderWidthFocused,
                color: colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
