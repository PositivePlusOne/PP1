// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';

class SecurityModePill extends ConsumerWidget {
  const SecurityModePill({
    required this.reactionMode,
    this.brightness = Brightness.light,
    super.key,
  });

  final ActivitySecurityConfigurationMode reactionMode;
  final Brightness brightness;

  String buildCommentVisibilityPillText(AppLocalizations localizations) {
    return reactionMode.when(
      public: () => localizations.shared_reaction_type_generic_everyone,
      followersAndConnections: () => localizations.shared_reaction_type_generic_followers,
      connections: () => localizations.shared_reaction_type_generic_connections,
      signedIn: () => localizations.shared_reaction_type_generic_signed_in,
      private: () => localizations.shared_reaction_type_generic_me,
      disabled: () => localizations.shared_reaction_type_generic_disabled,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));

    final String commentPillText = buildCommentVisibilityPillText(localizations);

    return Container(
      decoration: BoxDecoration(
        color: brightness == Brightness.light ? colours.colorGray1 : colours.white,
        borderRadius: BorderRadius.circular(kBorderRadiusLarge),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: kPaddingSmall,
        vertical: kPaddingExtraSmall,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            UniconsLine.comment_alt_notes,
            size: kIconExtraSmall,
            color: colours.colorGray6,
          ),
          const SizedBox(width: kPaddingExtraSmall),
          Text(
            commentPillText,
            style: typography.styleButtonBold.copyWith(color: colours.colorGray6),
          ),
        ],
      ),
    );
  }
}
