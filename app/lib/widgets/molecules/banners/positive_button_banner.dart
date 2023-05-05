// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/widgets/molecules/banners/positive_banner.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';

class PositiveButtonBanner extends StatelessWidget {
  const PositiveButtonBanner({
    super.key,
    required this.colors,
    required this.typography,
    required this.headingText,
    required this.bodyText,
    required this.buttonText,
    required this.onTapped,
  });

  final DesignColorsModel colors;
  final DesignTypographyModel typography;
  final String headingText;
  final String bodyText;
  final String buttonText;
  final FutureOr<void> Function() onTapped;

  @override
  Widget build(BuildContext context) {
    return PositiveBanner(
      key: key,
      colors: colors,
      typography: typography,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                headingText,
                style: typography.styleTitle.copyWith(
                  color: colors.black,
                ),
              ),
              Text(
                bodyText,
                style: typography.styleSubtitle.copyWith(
                  color: colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: kPaddingMedium),
        SizedBox(
            height: 30,
            child: TextButton(
              onPressed: onTapped,
              child: const Text('asdfasdfasdfasdfsf'),
            )),
      ],
    );
  }
}
