// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    this.borderRadius = kBorderRadiusLargePlus,
    this.borderWidth = kBorderThicknessSmall,
    this.forceBorder = false,
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
  final double borderRadius;
  final double borderWidth;
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
  final bool forceBorder;

  final int maxLines;
  final int minLines;

  final void Function(TextEditingController controller)? onControllerCreated;

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
    final Color textColour = widget.textStyle?.color ?? colors.black;
    final TextStyle labelStyle = widget.labelStyle ?? typography.styleButtonRegular;

    final bool hasBorder = isFocused || widget.forceBorder;

    final OutlineInputBorder baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        width: kPaddingNone,
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
      constraints: const BoxConstraints(
        minHeight: kCreatePostHeight,
        maxHeight: kCreatePostHeight,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: widget.fillColor ?? colors.white,
        border: Border.all(
          color: hasBorder ? widget.tintColor : widget.fillColor ?? colors.white,
          width: widget.borderWidth,
        ),
      ),
      padding: EdgeInsets.only(
        top: kPaddingExtraSmall - widget.borderWidth,
        bottom: kPaddingExtraSmall - widget.borderWidth,
        left: (widget.prefixIcon == null) ? kPaddingLarge - widget.borderWidth : kPaddingExtraSmall - widget.borderWidth,
        right: kPaddingExtraSmall - widget.borderWidth,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.prefixIcon != null) ...[
            PositiveTextFieldPrefixContainer(
              color: hasText || isFocused ? widget.tintColor : colors.colorGray2,
              child: widget.prefixIcon!,
            ),
            const SizedBox(width: kPaddingExtraSmall),
          ],
          Expanded(
            child: Transform.translate(
              offset: Offset(0, hasText || isFocused ? kPaddingExtraSmall : kPaddingNone),
              child: TextFormField(
                focusNode: textFocusNode,
                inputFormatters: [
                  if (widget.maxLengthEnforcement != MaxLengthEnforcement.none) LengthLimitingTextInputFormatter(widget.maxLength),
                ],
                enableSuggestions: true,
                obscureText: widget.obscureText,
                obscuringCharacter: kObscuringTextCharacter,
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
                  alignLabelWithHint: true,
                  labelText: useLengthLabel ? null : widget.labelText,
                  label: labelChild,
                  labelStyle: labelStyle.copyWith(
                    color: widget.labelColor ?? (hasText || isFocused ? widget.tintColor : textColour),
                    fontWeight: hasText || isFocused ? FontWeight.w800 : FontWeight.w600,
                  ),
                  hintText: widget.hintText,
                  hintStyle: typography.styleButtonRegular.copyWith(
                    color: textColour,
                    fontWeight: FontWeight.w600,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  contentPadding: const EdgeInsets.only(
                    top: kPaddingSmall,
                    bottom: kPaddingSmall,
                    left: kPaddingNone,
                    right: kPaddingNone,
                  ),
                  border: baseBorder,
                  disabledBorder: baseBorder,
                  errorBorder: baseBorder,
                  focusedErrorBorder: baseBorder,
                  enabledBorder: baseBorder,
                  focusedBorder: baseBorder,
                ),
              ),
            ),
          ),
          if (widget.suffixIcon != null) ...[
            const SizedBox(width: kPaddingExtraSmall),
            widget.suffixIcon!,
          ],
        ],
      ),
    );
  }
}
