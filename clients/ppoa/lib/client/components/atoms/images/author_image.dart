// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';

// Project imports:
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';

class AuthorImage extends StatelessWidget {
  const AuthorImage({
    required this.imageUrl,
    required this.authorDisplayName,
    required this.branding,
    this.ringColor,
    super.key,
  });

  final String imageUrl;
  final String authorDisplayName;

  final DesignSystemBrand branding;

  final Color? ringColor;

  static const double kContainerRadius = 40.0;
  static const double kImagePadding = 2.0;

  static const double kBorderWidth = 1.0;

  @override
  Widget build(BuildContext context) {
    final Color actualRingColor = ringColor ?? branding.colors.black;

    return Container(
      height: kContainerRadius,
      width: kContainerRadius,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: actualRingColor, width: kBorderWidth),
        borderRadius: BorderRadius.circular(kContainerRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kImagePadding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kContainerRadius),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (_, __) => Container(),
          ),
        ),
      ),
    );
  }
}
