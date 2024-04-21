// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/helpers/cache_helpers.dart';
import 'package:app/hooks/cache_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_close_button.dart';
import 'package:app/widgets/atoms/buttons/positive_invisible_icon_button.dart';
import 'package:app/widgets/atoms/input/positive_fake_text_field_button.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/molecules/tiles/profile_biography_tile.dart';
import 'package:app/widgets/organisms/profile/vms/profile_view_model.dart';

@RoutePage()
class ProfileDetailsPage extends HookConsumerWidget {
  const ProfileDetailsPage({
    required this.profileId,
    super.key,
  });

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileViewModelProvider provider = profileViewModelProvider(profileId);
    final ProfileViewModelState state = ref.watch(provider);

    final ProfileControllerState controllerState = ref.watch(profileControllerProvider);

    final CacheController cacheController = ref.read(cacheControllerProvider);
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    final String targetProfileId = state.targetProfileId ?? '';
    final Profile? targetProfile = cacheController.get(targetProfileId);

    final Profile? currentProfile = controllerState.currentProfile;

    final Iterable<String> keys = buildExpectedCacheKeysFromObjects(currentProfile, [targetProfile]);
    useCacheHook(keys: keys.toList());

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final bool canDisplayName = targetProfile?.visibilityFlags.contains(kVisibilityFlagName) == true;
    final String bannerText = canDisplayName ? targetProfile?.displayName.asHandle ?? '' : '';

    return PositiveScaffold(
      decorations: buildType2ScaffoldDecorations(colors),
      headingWidgets: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.only(bottom: kPaddingLarge),
          sliver: SliverToBoxAdapter(
            child: PositiveAppBar(
              title: bannerText,
              centerTitle: true,
              includeLogoWherePossible: false,
              decorationColor: colors.colorGray1,
              applyLeadingandTrailingPadding: true,
              safeAreaQueryData: mediaQueryData,
              leading: const PositiveCloseButton(),
              trailing: const [
                PositiveInvisibleButton(),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              if (targetProfile?.biography.isNotEmpty == true) ...<Widget>[
                Container(
                  padding: const EdgeInsets.only(left: kPaddingMedium, right: kPaddingMedium, bottom: kPaddingSmallMedium),
                  child: ProfileBiographyTile(
                    profile: targetProfile!,
                    isBusy: state.isBusy,
                    displayDetailsOption: false,
                  ),
                ),
              ],
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(left: kPaddingMedium, right: kPaddingMedium, bottom: kPaddingSmallMedium),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=- Company Sector -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                if (targetProfile?.isOrganisation == true) ...[
                  PositiveFakeTextFieldButton.profile(
                    hintText: localisations.page_profile_view_company_sectors,
                    labelText: targetProfile?.formattedCompanySectorsIgnoreFlags,
                  ),
                  const SizedBox(height: kPaddingMedium),
                ],

                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- *\\
                //* -=-=-=-=-=- Date of Birth -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- *\\
                if (!(targetProfile?.isOrganisation ?? false)) ...[
                  PositiveFakeTextFieldButton(
                    hintText: localisations.page_profile_view_age,
                    labelText: targetProfile?.formattedAgeRespectingFlags ?? '',
                    //? empty onTap, users may not update date of birth in app
                  ),
                  const SizedBox(height: kPaddingMedium),

                  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                  //* -=-=-=-=-=- Gender -=-=-=-=-=- *\\
                  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                  PositiveFakeTextFieldButton.profile(
                    hintText: localisations.page_profile_view_gender,
                    labelText: targetProfile?.formattedGenderRespectingFlags,
                  ),
                  const SizedBox(height: kPaddingMedium),

                  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                  //* -=-=-=-=- HIV Status -=-=-=-=- *\\
                  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                  PositiveFakeTextFieldButton.profile(
                    hintText: localisations.page_profile_view_hiv_status,
                    labelText: targetProfile?.formattedHIVStatusRespectingFlags,
                  ),
                  const SizedBox(height: kPaddingMedium),
                ],

                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=- Location -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                PositiveFakeTextFieldButton.profile(
                  hintText: localisations.page_profile_view_location,
                  labelText: targetProfile?.formattedLocationRespectingFlags,
                ),
                const SizedBox(height: kPaddingMedium),

                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=- Your Interests -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                PositiveFakeTextFieldButton.profile(
                  hintText: localisations.page_profile_view_interests,
                  labelText: targetProfile?.formattedInterestsRespectingFlags,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
