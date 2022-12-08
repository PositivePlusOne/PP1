import 'package:flutter/material.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/constants/ppo_design_constants.dart';

class PPOTextField extends StatefulWidget {
  const PPOTextField({
    required this.branding,
    required this.label,
    this.initialValue = '',
    this.primaryColor,
    super.key,
  });

  final DesignSystemBrand branding;
  final String label;
  final String initialValue;

  final Color? primaryColor;

  static const double kBorderRadius = 100.0;
  static const double kBorderWidthTextField = 0.0;
  static const double kBorderWidthContainer = 1.0;

  static const EdgeInsets kEdgeInsetsDefault = EdgeInsets.only(
    left: 30.0,
    right: 30.0,
    top: 15.0,
    bottom: 10.0,
  );

  static const EdgeInsets kEdgeInsetsLabelHovered = EdgeInsets.only(top: 25.0);

  static const Curve kLabelCurve = Curves.linearToEaseOut;

  static const TextStyle kFloatingLabelTextStyle = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w800,
    fontFamily: kFontAlbertSans,
  );

  static const TextStyle kLabelTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    fontFamily: kFontAlbertSans,
  );

  @override
  State<PPOTextField> createState() => _PPOTextFieldState();
}

class _PPOTextFieldState extends State<PPOTextField> {
  late TextEditingController textEditingController;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
    focusNode.addListener(onFocusNodeListener);

    textEditingController = TextEditingController(text: widget.initialValue);
    textEditingController.addListener(onTextEditingListener);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void onTextEditingListener() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  void onFocusNodeListener() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool isFocused = focusNode.hasFocus;
    final bool hasText = textEditingController.text.isNotEmpty;

    final Color actualPrimaryColor = widget.primaryColor ?? widget.branding.colors.purple;

    final InputDecoration decoration = InputDecoration(
      label: AnimatedPadding(
        duration: kAnimationDurationRegular,
        curve: PPOTextField.kLabelCurve,
        padding: isFocused || hasText ? PPOTextField.kEdgeInsetsLabelHovered : EdgeInsets.zero,
        child: Text(widget.label),
      ),
      labelStyle: PPOTextField.kLabelTextStyle.copyWith(color: widget.branding.colors.black),
      isCollapsed: true,
      fillColor: Colors.transparent,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(PPOTextField.kBorderRadius),
        borderSide: const BorderSide(
          width: PPOTextField.kBorderWidthTextField,
          style: BorderStyle.none,
        ),
      ),
      contentPadding: PPOTextField.kEdgeInsetsDefault,
      floatingLabelStyle: PPOTextField.kFloatingLabelTextStyle.copyWith(color: actualPrimaryColor),
      floatingLabelAlignment: FloatingLabelAlignment.start,
    );

    return AnimatedContainer(
      duration: kAnimationDurationRegular,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(PPOTextField.kBorderRadius),
        border: Border.all(
          color: isFocused ? actualPrimaryColor : Colors.transparent,
          width: PPOTextField.kBorderWidthContainer,
        ),
        color: widget.branding.colors.white,
      ),
      child: TextField(
        controller: textEditingController,
        focusNode: focusNode,
        style: PPOTextField.kLabelTextStyle.copyWith(color: widget.branding.colors.black),
        cursorColor: actualPrimaryColor,
        decoration: decoration,
        // textAlignVertical: TextAlignVertical.top,
      ),
    );
  }
}
