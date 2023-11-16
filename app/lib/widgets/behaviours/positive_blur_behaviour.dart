// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';

class PositiveBlurBehaviour extends StatelessWidget {
  const PositiveBlurBehaviour({
    required this.child,
    this.sigmaBlur = PositiveGlassSheet.kGlassContainerSigmaBlur,
    this.excludeBlur = false,
    super.key,
  });

  final Widget child;
  final double sigmaBlur;

  final bool excludeBlur;

  @override
  Widget build(BuildContext context) {
    final ImageFilter filter = ImageFilter.blur(sigmaX: sigmaBlur, sigmaY: sigmaBlur);

    if (excludeBlur) {
      return child;
    }

    return BackdropFilter(
      filter: filter,
      child: child,
    );
  }
}
