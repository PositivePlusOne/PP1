// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/enrichment/promotions.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/main.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytic_properties.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_layout.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_size.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';

class PromotionButton extends StatelessWidget {
  const PromotionButton({
    required this.promotion,
    this.activity,
    this.borderRadius = kBorderRadiusLarge,
    this.isEnabled = true,
    super.key,
  });

  final Promotion promotion;
  final Activity? activity;

  final double borderRadius;
  final bool isEnabled;

  Future<void> onLinkTapped(BuildContext context, String link) async {
    final AnalyticsController analyticsController = providerContainer.read(analyticsControllerProvider.notifier);
    final Logger logger = providerContainer.read(loggerProvider);
    logger.d('PromotionButton.onLinkTapped: $link');

    if (link.isNotEmpty) {
      await analyticsController.trackEvent(
        AnalyticEvents.postPromotionViewed,
        properties: generatePropertiesForPromotionSource(promotion: promotion, activity: activity),
      );

      await link.attemptToLaunchURL();
    }
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
    return PositiveGlassSheet(
      borderRadius: borderRadius,
      children: <Widget>[
        PositiveButton(
          isDisabled: !isEnabled,
          isActive: true,
          onTapped: () => onLinkTapped(context, promotion.link),
          colors: colors,
          primaryColor: colors.black,
          label: promotion.title,
          size: PositiveButtonSize.small,
          style: PositiveButtonStyle.primary,
          layout: PositiveButtonLayout.iconRight,
          // and if there is a link - hint that we can go to it
          icon: promotion.link.isNotEmpty ? Icons.navigate_next : null,
        ),
      ],
    );
  }
}
