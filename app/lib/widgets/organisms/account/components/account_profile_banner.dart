// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/feedback/feedback_type.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import '../../../../providers/system/design_controller.dart';
import '../../../atoms/buttons/positive_button.dart';
import '../../../atoms/indicators/positive_profile_circular_indicator.dart';
import '../vms/account_view_model.dart';

class AccountProfileBanner extends ConsumerWidget implements PreferredSizeWidget {
  const AccountProfileBanner({
    super.key,
    required this.profile,
  });

  final Profile? profile;

  static const double kBannerHeight = 80.0;
  static const double kBannerRadius = 20.0;

  static const double kSubtextOpacity = 0.4;

  @override
  Size get preferredSize => const Size.fromHeight(kBannerHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final AccountViewModelProvider viewModelProvider = accountViewModelProvider.call(const FeedbackType.genericFeedback());
    final AccountViewModel viewModel = ref.watch(viewModelProvider.notifier);

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final ProfileControllerState profileControllerState = ref.watch(profileControllerProvider);
    final Profile? currentProfile = profileControllerState.currentProfile;
    final bool isOrganisation = currentProfile?.isOrganisation == true;

    final bool isViewingOwnProfile = profile != null && profile?.flMeta?.id == currentProfile?.flMeta?.id;

    String displayName = profile?.displayName ?? '';
    if (displayName.isEmpty) {
      displayName = localizations.shared_placeholders_empty_display_name;
    }

    String name = profile?.name ?? '';
    if (name.isEmpty) {
      name = localizations.shared_placeholders_empty_name;
    }

    return Container(
      height: kBannerHeight,
      width: double.infinity,
      padding: const EdgeInsets.all(kPaddingMedium),
      decoration: BoxDecoration(
        color: colors.colorGray1,
        borderRadius: BorderRadius.circular(kBannerRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          PositiveProfileCircularIndicator(
            profile: profile ?? Profile.empty(),
            onTap: () {},
          ),
          const SizedBox(width: kPaddingSmall),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    displayName.asHandle,
                    style: typography.styleTitle,
                  ),
                ),
                Text(
                  name,
                  style: typography.styleSubtext.copyWith(
                    color: colors.black.withOpacity(kSubtextOpacity),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: kPaddingSmall),
          PositiveButton.appBarIcon(
            colors: colors,
            icon: UniconsLine.eye,
            onTapped: () => viewModel.onViewProfileButtonSelected(profile),
            tooltip: localizations.page_account_actions_view_profile,
          ),
          if (isViewingOwnProfile && !isOrganisation) ...<Widget>[
            const SizedBox(width: kPaddingSmall),
            PositiveButton.appBarIcon(
              colors: colors,
              icon: UniconsLine.pen,
              onTapped: viewModel.onEditAccountButtonPressed,
              tooltip: localizations.page_account_actions_edit_profile,
            ),
          ],
        ],
      ),
    );
  }
}
