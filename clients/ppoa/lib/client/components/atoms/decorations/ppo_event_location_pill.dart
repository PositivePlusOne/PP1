// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:ppoa/business/extensions/brand_extensions.dart';
import 'package:ppoa/business/state/content/event_location.dart';
import 'package:ppoa/business/state/design_system/models/design_system_brand.dart';
import 'package:ppoa/client/constants/ppo_design_constants.dart';

class PPOEventLocationPill extends StatelessWidget {
  const PPOEventLocationPill({
    required this.branding,
    required this.eventLocation,
    super.key,
  });

  final DesignSystemBrand branding;
  final EventLocation eventLocation;

  static const EdgeInsets kPillPadding = EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0);

  static const double kPillRadius = 100.0;
  static const double kPillOpacity = 0.40;

  static const double kPillLocationIconRadius = 18.0;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    String place = eventLocation.locationCountry;

    if (eventLocation.locationCity.isNotEmpty) {
      place = eventLocation.locationCity;
    }

    if (eventLocation.locationTown.isNotEmpty) {
      place = eventLocation.locationTown;
    }

    if (place.isEmpty) {
      place = localizations.shared_events_tooltips_unknown_location;
    }

    return Container(
      padding: kPillPadding,
      decoration: BoxDecoration(
        color: branding.colors.white.withOpacity(kPillOpacity),
        borderRadius: BorderRadius.circular(kPillRadius),
      ),
      child: Row(
        children: <Widget>[
          Icon(UniconsLine.location_point, color: branding.colors.colorGray7, size: kPillLocationIconRadius),
          kPaddingExtraSmall.asHorizontalWidget,
          Text(
            place,
            style: branding.typography.styleButtonRegular.copyWith(color: branding.colors.colorGray7),
          ),
        ],
      ),
    );
  }
}
