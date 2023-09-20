import 'package:app/constants/design_constants.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class PositiveVerifiedBadge extends StatelessWidget {
  const PositiveVerifiedBadge({
    super.key,
    required this.accentColor,
    required this.complementaryColor,
  });

  final Color accentColor;
  final Color complementaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kIconSmall,
      height: kIconSmall,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        color: accentColor,
      ),
      alignment: Alignment.center,
      child: Icon(
        UniconsLine.check,
        size: kIconExtraSmall,
        color: complementaryColor,
      ),
    );
  }
}
