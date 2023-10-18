// Flutter imports:
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/services/third_party.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

// Project imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/design_constants.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';

class ProfileBiographyTile extends ConsumerWidget {
  const ProfileBiographyTile({
    required this.profile,
    super.key,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    if (profile.biography.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          localizations.shared_actions_about,
          style: typography.styleSubtitleBold.copyWith(color: colors.colorGray3),
        ),
        const SizedBox(height: kPaddingSmallMedium),
        // we allow links for companies so show those nice and blue
        if (profile.isOrganisation)
          Linkify(
            onOpen: (link) => launchUrl(Uri.parse(link.url)),
            text: profile.biography,
            style: typography.styleSubtitle.copyWith(color: colors.black),
          ),
        // if not an org - we only allow text to be shown here
        if (!profile.isOrganisation)
          Text(
            profile.biography,
            style: typography.styleSubtitle.copyWith(color: colors.black),
          ),
      ],
    );
  }
}
