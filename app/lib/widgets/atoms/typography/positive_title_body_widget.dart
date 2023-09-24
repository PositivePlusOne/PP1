import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PositiaveTitleBodyWidget extends ConsumerWidget {
  const PositiaveTitleBodyWidget({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: typography.styleHero.copyWith(
                color: colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: kPaddingMedium),
        Text(
          body,
          textAlign: TextAlign.left,
          style: typography.styleBody.copyWith(
            color: colors.black,
          ),
        ),
      ],
    );
  }
}
