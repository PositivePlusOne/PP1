// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/extensions/number_extensions.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/banners/positive_banner.dart';
import '../../../constants/design_constants.dart';
import '../../../providers/system/design_controller.dart';

class PositiveButtonBanner extends ConsumerWidget {
  const PositiveButtonBanner({
    super.key,
    required this.heading,
    required this.body,
    required this.buttonText,
    required this.onTapped,
  });

  final String heading;
  final String body;
  final String buttonText;
  final FutureOr<void> Function() onTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final colors = ref.watch(designControllerProvider.select((design) => design.colors));

    return PositiveBanner(
      key: key,
      colors: colors,
      typography: typography,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  heading,
                  style: typography.styleTitleTwo.copyWith(
                    color: colors.black,
                  ),
                ),
                Text(
                  body,
                  style: typography.styleBody.copyWith(
                    color: colors.black,
                  ),
                ),
              ],
            ),
          ),
          kPaddingMedium.asHorizontalBox,
          PositiveButton(
            colors: colors,
            onTapped: onTapped,
            label: buttonText,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 20),
          )
        ],
      ),
    );
  }
}
