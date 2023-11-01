// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';

class PromotionButton extends StatelessWidget {
  const PromotionButton({
    super.key,
    required this.link,
    required this.linkText,
    this.borderRadius = kBorderRadiusLarge,
    this.isEnabled = true,
  });

  final String link;
  final String linkText;

  final double borderRadius;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
    return PositiveGlassSheet(
      borderRadius: borderRadius,
      children: <Widget>[
        PositiveButton(
          isDisabled: !isEnabled,
          isActive: true,
          onTapped: () => link.isNotEmpty ? () => link.attemptToLaunchURL() : () {},
          colors: colors,
          primaryColor: colors.black,
          label: linkText,
          size: PositiveButtonSize.small,
          style: PositiveButtonStyle.primary,
          layout: PositiveButtonLayout.iconRight,
          // and if there is a link - hint that we can go to it
          icon: link.isNotEmpty ? Icons.navigate_next : null,
        ),
      ],
    );
  }
}
