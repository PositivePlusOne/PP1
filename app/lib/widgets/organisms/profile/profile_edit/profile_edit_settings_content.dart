import 'package:app/dtos/system/design_colors_model.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../constants/design_constants.dart';
import '../../../../dtos/system/design_typography_model.dart';
import '../../../../main.dart';
import '../../../../providers/system/design_controller.dart';

class CheckboxWithText extends StatefulWidget {
  const CheckboxWithText({
    required this.toggleState,
    super.key,
  });

  final ToggleState toggleState;

  @override
  State<CheckboxWithText> createState() => _CheckboxWithTextState();
}

class _CheckboxWithTextState extends State<CheckboxWithText> with SingleTickerProviderStateMixin {
  late DesignTypographyModel typography;
  late DesignColorsModel colors;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    typography = providerContainer.read(designControllerProvider.select((value) => value.typography));
    colors = providerContainer.read(designControllerProvider.select((value) => value.colors));

    _controller = AnimationController(
      vsync: this,
      duration: kAnimationDurationSlow,
    );
    _controller.addListener(onControllerTick);
    _controller.forward();
  }

  void onControllerTick() {
    if (!mounted) return;
    if (_controller.isCompleted) {
      _controller.forward(from: 0.0);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(onControllerTick);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    double toggleSize = kIconMedium;
    Widget toggleIconWidget;
    String text;

    switch (widget.toggleState) {
      case ToggleState.loading:
        toggleIconWidget = CustomPaint(
          painter: CheckBoxPainter(animation: _controller.value),
          size: Size(toggleSize, toggleSize),
        );
        text = localizations.shared_actions_updating;
        break;

      case ToggleState.active:
        toggleIconWidget = Container(
          width: toggleSize,
          height: toggleSize,
          decoration: BoxDecoration(
            color: colors.green,
            borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          ),
          child: Icon(
            UniconsLine.check,
            color: colors.black,
            size: kIconSmall,
          ),
        );
        text = localizations.molecule_display_in_app_display;
        break;

      case ToggleState.alwaysActive:
        toggleIconWidget = SizedBox(
          width: toggleSize,
          height: toggleSize,
          child: Icon(
            UniconsLine.eye,
            color: colors.green,
            size: kIconMedium,
          ),
        );
        text = localizations.molecule_display_in_app_always_display;
        break;

      case ToggleState.inactive:
      default:
        toggleIconWidget = SizedBox(
          width: toggleSize,
          height: toggleSize,
          child: Icon(
            UniconsLine.eye_slash,
            color: colors.black,
            size: kIconSmall,
          ),
        );
        text = localizations.molecule_display_in_app_no_display;
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.colorGray3.withOpacity(kOpacityQuarter),
        borderRadius: BorderRadius.circular(kBorderRadiusMedium),
      ),
      padding: const EdgeInsets.all(kPaddingExtraSmall),
      child: Row(
        children: [
          const SizedBox(width: kPaddingExtraSmall),
          toggleIconWidget,
          const SizedBox(width: kPaddingSmall),
          Text(
            text,
            style: typography.styleSubtitle,
          ),
        ],
      ),
    );
  }
}

class CheckBoxPainter extends CustomPainter {
  CheckBoxPainter({
    required this.animation,
  });

  double animation;

  @override
  void paint(Canvas canvas, Size size) {
    double animationLooped;

    if (animation <= 0.5) {
      animationLooped = animation * 2;
    } else {
      animationLooped = (1.0 - animation) * 2;
    }
    Paint paint3 = Paint()
      ..color = Colors.black.withOpacity(animationLooped)
      ..style = PaintingStyle.fill;

    animation += 0.333;
    if (animation > 1.0) animation = animation - 1;
    if (animation <= 0.5) {
      animationLooped = animation * 2;
    } else {
      animationLooped = (1.0 - animation) * 2;
    }
    Paint paint2 = Paint()
      ..color = Colors.black.withOpacity(animationLooped)
      ..style = PaintingStyle.fill;

    animation += 0.333;
    if (animation > 1.0) animation -= 1;

    if (animation <= 0.5) {
      animationLooped = animation * 2;
    } else {
      animationLooped = (1.0 - animation) * 2;
    }
    Paint paint1 = Paint()
      ..color = Colors.black.withOpacity(animationLooped)
      ..style = PaintingStyle.fill;

    double circleRadius = 2.0;
    double yPos = (size.height / 2);

    canvas.drawCircle(Offset(circleRadius, yPos), circleRadius, paint1);
    canvas.drawCircle(Offset((size.width / 2), yPos), circleRadius, paint2);
    canvas.drawCircle(Offset(size.width - circleRadius, yPos), circleRadius, paint3);
  }

  @override
  bool shouldRepaint(CheckBoxPainter oldDelegate) {
    if (animation != oldDelegate.animation) {
      return true;
    }
    return false;
  }
}

enum ToggleState {
  active,
  inactive,
  loading,
  alwaysActive,
}
