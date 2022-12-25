import 'package:flutter/material.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/constants/ppo_design_constants.dart';

class HomeRecommendedFeature extends StatelessWidget {
  const HomeRecommendedFeature({
    required this.title,
    required this.imagePath,
    required this.displayName,
    required this.postedTime,
    required this.branding,
    this.eventTime,
    this.eventLocation,
    super.key,
  });

  final String title;

  final DateTime? eventTime;
  final String? eventLocation;

  final String imagePath;
  final String displayName;
  final DateTime postedTime;

  final DesignSystemBrand branding;

  @override
  Widget build(BuildContext context) {
    final int maxLines = (eventTime != null || eventLocation != null) ? 2 : 3;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Recommended',
            style: branding.typography.styleBody.copyWith(
              color: branding.colors.black.withOpacity(0.5),
            ),
          ),
          Text(
            title,
            maxLines: maxLines,
            style: branding.typography.styleHero.copyWith(color: branding.colors.black),
          ),
        ],
      ),
    );
  }
}
