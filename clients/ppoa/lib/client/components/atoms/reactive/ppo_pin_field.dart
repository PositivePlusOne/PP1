import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ppoa/resources/resources.dart';

class PPOPinField extends StatefulWidget {
  const PPOPinField({
    required this.onSubmittion,
    this.focusNode,
    this.size = 45.0,
    this.requestFocusOnRender = false,
    super.key,
  });
  static int maxFieldLength = 6;
  final double size;
  final Function(String) onSubmittion;
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
    controller.addListener(
      () {
        if (mounted) {
          setState(() {});
        }
      },
    );
    focusNode = widget.focusNode ?? FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.requestFocusOnRender) {
        focusNode.requestFocus();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pinFields = [];

    for (var i = 0; i < PPOPinField.maxFieldLength; i++) {
      if (i < controller.text.length) {
        pinFields.add(PinFieldChar(active: (controller.value.text[i].isNotEmpty), size: widget.size));
        continue;
      }
      pinFields.add(PinFieldChar(active: false, size: widget.size));
    }

    return GestureDetector(
      onTapDown: (_) {
        focusNode.requestFocus();
      },
      child: Column(
        children: [
          Offstage(
            offstage: true,
            child: TextField(
              controller: controller,
              maxLength: PPOPinField.maxFieldLength,
              focusNode: focusNode,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onSubmitted: widget.onSubmittion,
            ),
          ),
          SizedBox(
            width: PPOPinField.maxFieldLength * widget.size,
            child: Row(
              children: <Widget>[...pinFields],
            ),
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
    required this.active,
    required this.size,
    this.boxSize = 5.0,
    super.key,
  });

  final bool active;
  final double size;
  final double boxSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(
            left: (size - boxSize) / 2,
            top: (size - boxSize) / 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
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
                opacity: active ? 1.0 : 0.0,
                duration: Duration(milliseconds: 200),
                child: SvgPicture.asset(SvgImages.decorationFlower),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
