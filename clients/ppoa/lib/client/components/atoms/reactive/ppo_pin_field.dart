import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ppoa/business/extensions/brand_extensions.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/constants/ppo_design_constants.dart';
import 'package:ppoa/resources/resources.dart';

class PPOPinField extends StatefulWidget {
  const PPOPinField({
    required this.branding,
    required this.onChanged,
    this.focusNode,
    this.itemSize = 45.0,
    this.itemCount = 6,
    this.spacing = 8.0,
    this.isError = false,
    this.requestFocusOnRender = false,
    super.key,
  });

  final double itemSize;
  final int itemCount;

  final double spacing;

  final DesignSystemBrand branding;
  final bool isError;

  final Function(String) onChanged;

  final bool requestFocusOnRender;
  final FocusNode? focusNode;

  @override
  State<PPOPinField> createState() => _PPOPinFieldState();
}

class _PPOPinFieldState extends State<PPOPinField> {
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    controller = TextEditingController();
    controller.addListener(onTextControllerChanged);

    focusNode = widget.focusNode ?? FocusNode();
    WidgetsBinding.instance.addPostFrameCallback(onFirstRender);

    super.initState();
  }

  void onTextControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void onFirstRender(Duration timeStamp) {
    if (mounted && widget.requestFocusOnRender) {
      focusNode.requestFocus();
    }
  }

  void onTapped() {
    if (mounted) {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pinFields = [];
    final bool isComplete = controller.text.length == widget.itemCount;

    for (var i = 0; i < widget.itemCount; i++) {
      if (i < controller.text.length) {
        final Widget pinField = PinFieldChar(
          isFilled: (controller.value.text[i].isNotEmpty),
          isComplete: isComplete,
          branding: widget.branding,
          isError: widget.isError,
          size: widget.itemSize,
        );

        pinFields.add(pinField);
        continue;
      }

      final Widget pinField = PinFieldChar(
        isFilled: false,
        isComplete: isComplete,
        branding: widget.branding,
        isError: widget.isError,
        size: widget.itemSize,
      );

      pinFields.add(pinField);
    }

    return GestureDetector(
      onTap: onTapped,
      child: Column(
        children: <Widget>[
          Offstage(
            offstage: true,
            child: TextField(
              controller: controller,
              maxLength: widget.itemCount,
              focusNode: focusNode,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: widget.onChanged,
            ),
          ),
          Wrap(
            runSpacing: widget.spacing,
            spacing: widget.spacing,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.start,
            children: pinFields,
          ),
        ],
      ),
    );
  }
}

class PPOPinFieldController {
  List<String> code = [];
  int index = 0;
}

class PinFieldChar extends StatelessWidget {
  const PinFieldChar({
    required this.isFilled,
    required this.isComplete,
    required this.size,
    required this.branding,
    this.isError = false,
    this.boxSize = 5.0,
    this.inactiveOpacity = 0.25,
    super.key,
  });

  final bool isFilled;
  final bool isComplete;

  final double size;
  final double boxSize;
  final double inactiveOpacity;

  final DesignSystemBrand branding;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    Color color = branding.colors.black;
    if (isComplete) {
      color = branding.colors.green;
    }

    if (isError) {
      color = branding.colors.red;
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: (size - boxSize) / 2,
              top: (size - boxSize) / 2,
              child: Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(inactiveOpacity),
                  borderRadius: BorderRadius.circular(boxSize),
                ),
                height: boxSize,
                width: boxSize,
              ),
            ),
            Positioned(
              left: 0.0,
              top: 0.0,
              child: SizedBox(
                width: size,
                height: size,
                child: AnimatedOpacity(
                  opacity: isFilled ? kOpacityFull : kOpacityNone,
                  duration: kAnimationDurationRegular,
                  child: SvgPicture.asset(SvgImages.decorationFlower, color: color),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
