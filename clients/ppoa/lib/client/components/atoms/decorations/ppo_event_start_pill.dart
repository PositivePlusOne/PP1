import 'package:flutter/material.dart';

import 'package:ppoa/business/state/content/event_time.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';

class PPOEventStartPill extends StatelessWidget {
  const PPOEventStartPill({
    required this.branding,
    required this.eventTime,
    super.key,
  });

  final DesignSystemBrand branding;
  final EventTime eventTime;

  static const EdgeInsets kPillPadding = EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0);

  static const double kPillRadius = 100.0;
  static const double kPillOpacity = 0.40;

  @override
  Widget build(BuildContext context) {
    final DateTime startTime = eventTime.startTime!;

    return Container(
      padding: kPillPadding,
      decoration: BoxDecoration(
        color: branding.colors.white.withOpacity(kPillOpacity),
        borderRadius: BorderRadius.circular(kPillRadius),
      ),
      child: Text(
        startTime.toIso8601String(),
        style: branding.typography.styleButtonRegular.copyWith(color: branding.colors.colorGray7),
      ),
    );
  }
}
