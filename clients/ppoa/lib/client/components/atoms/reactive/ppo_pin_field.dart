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

class _PPOPinFieldState extends State<PPOPinField> with SingleTickerProviderStateMixin {
  late TextEditingController controller;
  late FocusNode focusNode;
  late AnimationController animationController;
  late Animation<Color?> animationColour;
  late Color endColour;

  @override
  void initState() {
    controller = TextEditingController();
    controller.addListener(onTextControllerChanged);

    endColour = widget.isError ? widget.branding.colors.red : widget.branding.colors.green;
    animationController = AnimationController(vsync: this, duration: kAnimationDurationRegular);
    animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    animationColour = ColorTween(begin: widget.branding.colors.black, end: endColour).animate(animationController);

    focusNode = widget.focusNode ?? FocusNode();
    WidgetsBinding.instance.addPostFrameCallback(onFirstRender);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant PPOPinField oldWidget) {
    if (mounted) {
      endColour = widget.isError ? widget.branding.colors.red : widget.branding.colors.green;
    }
    super.didUpdateWidget(oldWidget);
  }

  void onTextControllerChanged() {
    if (mounted) {
      if (controller.text.length == widget.itemCount) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
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
          branding: widget.branding,
          size: widget.itemSize,
          color: animationColour.value ?? widget.branding.colors.black,
        );

        pinFields.add(pinField);
        continue;
      }

      final Widget pinField = PinFieldChar(
        isFilled: false,
        branding: widget.branding,
        size: widget.itemSize,
        color: animationColour.value ?? widget.branding.colors.black,
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
    required this.size,
    required this.branding,
    required this.color,
    this.boxSize = 5.0,
    this.inactiveOpacity = 0.25,
    super.key,
  });

  final bool isFilled;

  final double size;
  final double boxSize;
  final double inactiveOpacity;

  final Color color;

  final DesignSystemBrand branding;

  @override
  Widget build(BuildContext context) {
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
