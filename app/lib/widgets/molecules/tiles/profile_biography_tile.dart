// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';

class ProfileBiographyTile extends ConsumerWidget {
  const ProfileBiographyTile({
    required this.profile,
    required this.isBusy,
    this.displayDetailsOption = true,
    super.key,
  });

  final Profile profile;
  final bool isBusy;

  final bool displayDetailsOption;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          localizations.shared_actions_about,
          style: typography.styleSubtitleBold.copyWith(color: colors.colorGray3),
        ),
        // we allow links for companies so show those nice and blue
        if (profile.isOrganisation && profile.biography.isNotEmpty) ...<Widget>[
          Linkify(
            onOpen: (link) => launchUrl(Uri.parse(link.url)),
            text: profile.biography,
            style: typography.styleSubtitle.copyWith(color: colors.black),
          ),
        ],
        // if not an org - we only allow text to be shown here
        if (!profile.isOrganisation && profile.biography.isNotEmpty) ...<Widget>[
          Text(
            profile.biography,
            style: typography.styleSubtitle.copyWith(color: colors.black),
          ),
        ],
        if (displayDetailsOption) ...<Widget>[
          PositiveTapBehaviour(
            onTap: (_) => profile.navigateToProfileDetails(),
            isEnabled: !isBusy,
            child: Text(
              'View More',
              style: typography.styleSubtitleBold.copyWith(color: colors.colorGray7),
            ),
          ),
        ],
      ].spaceWithVertical(kPaddingSmall),
    );
  }
}
