// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/extensions/number_extensions.dart';
import 'package:app/main.dart';
import '../../../providers/system/design_controller.dart';

class PositiveSnackBar extends SnackBar {
  PositiveSnackBar({super.key, required Widget content})
      : super(
          margin: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
          behavior: SnackBarBehavior.floating,
          backgroundColor: providerContainer.read(designControllerProvider.select((value) => value.colors)).black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          content: content,
        );
}

class PositiveFollowSnackBar extends PositiveSnackBar {
  PositiveFollowSnackBar({super.key, required String text})
      : super(
          content: Builder(builder: (context) {
            final colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
            final typography = providerContainer.read(designControllerProvider.select((value) => value.typography));

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(UniconsLine.check_circle, color: colors.white),
                    kPaddingSmall.asHorizontalBox,
                    Expanded(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: typography.styleBody,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        );
}
