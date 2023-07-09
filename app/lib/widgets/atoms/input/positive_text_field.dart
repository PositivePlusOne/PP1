// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
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
    this.textEditingController,
    this.maxLength,
    this.maxLengthEnforcement = MaxLengthEnforcement.none,
    this.borderRadius = kBorderRadiusLargePlus,
    this.borderWidth = kBorderThicknessSmall,
    this.forceBorder = false,
    this.textStyle,
    this.labelColor,
    this.labelStyle,
    this.showRemaining = false,
    this.showRemainingStyle,
    super.key,
  });

  final String initialText;
  final String? hintText;
  final TextStyle? textStyle;
  final int? maxLength;
  final MaxLengthEnforcement maxLengthEnforcement;
  final double borderRadius;
  final double borderWidth;

  final Widget? label;
  final String? labelText;
  final Color? labelColor;
  final TextStyle? labelStyle;

  final bool showRemaining;
  final TextStyle? showRemainingStyle;

  final Function(String str)? onTextChanged;
  final Function(String str)? onTextSubmitted;
  final Function(bool isFocused)? onFocusedChanged;

  final Color tintColor;
  final Color? fillColor;

  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final TextEditingController? textEditingController;

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
    textEditingController = widget.textEditingController ?? TextEditingController(text: widget.initialText);
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
    final DesignColorsModel colours = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final localisations = AppLocalizations.of(context)!;

    final bool hasText = textEditingController.text.isNotEmpty;
    final bool hasTextIsFocused = hasText || isFocused;

    final Color textColour = widget.textStyle?.color ?? colours.black;
    final TextStyle labelStyle = widget.labelStyle ?? typography.styleButtonRegular;

    final bool hasBorder = isFocused || widget.forceBorder;

    final OutlineInputBorder baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        width: kPaddingNone,
        style: BorderStyle.none,
        color: colours.transparent,
      ),
    );

    Widget? labelChild;
    if (widget.label != null) {
      labelChild = widget.label;
    }

    if (widget.showRemaining && widget.maxLength != null && (hasTextIsFocused || textEditingController.text.isNotEmpty)) {
      int remainingCharacters = widget.maxLength! - textEditingController.text.length;
      labelChild = RichText(
        text: TextSpan(
          style: widget.labelStyle ?? typography.styleButtonRegular,
          text: widget.labelText,
          children: [
            TextSpan(
              style: widget.showRemainingStyle ?? typography.styleButtonRegular.copyWith(color: colours.colorGray4),
              text: localisations.page_create_post_caption_remaining_characters(remainingCharacters),
            ),
          ],
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(minHeight: kCreatePostHeight),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: widget.fillColor ?? colours.white,
        border: Border.all(
          color: hasBorder ? widget.tintColor : widget.fillColor ?? colours.white,
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
              color: hasTextIsFocused ? widget.tintColor : colours.colorGray2,
              child: widget.prefixIcon!,
            ),
            const SizedBox(width: kPaddingExtraSmall),
          ],
          Expanded(
            child: AnimatedPadding(
              padding: EdgeInsetsDirectional.only(top: hasTextIsFocused && widget.labelText != null ? kPaddingExtraSmall : kPaddingNone),
              duration: kAnimationDurationFast,
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
                  alignLabelWithHint: true,
                  label: labelChild,
                  labelText: labelChild == null ? widget.labelText : null,
                  labelStyle: labelStyle.copyWith(
                    color: widget.labelColor ?? (hasTextIsFocused ? widget.tintColor : textColour),
                    fontWeight: hasTextIsFocused ? FontWeight.w800 : FontWeight.w600,
                  ),
                  hintText: widget.hintText,
                  hintStyle: typography.styleButtonRegular.copyWith(
                    color: textColour,
                    fontWeight: FontWeight.w600,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  contentPadding: const EdgeInsets.only(
                    top: kPaddingSmall,
                    bottom: kPaddingNone,
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
