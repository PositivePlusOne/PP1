// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/user/mixins/profile_switch_mixin.dart';
import '../../../../hooks/lifecycle_hook.dart';

part 'account_page_view_model.freezed.dart';
part 'account_page_view_model.g.dart';

@freezed
class AccountPageViewModelState with _$AccountPageViewModelState {
  const factory AccountPageViewModelState({
    @Default(false) bool isBusy,
    @Default(Colors.white) Color profileAccentColour,
    @Default(Colors.white) Color organisationAccentColour,
  }) = _AccountPageViewModelState;

  factory AccountPageViewModelState.initialState() => const AccountPageViewModelState(
        isBusy: false,
      );
}

@Riverpod()
class AccountPageViewModel extends _$AccountPageViewModel with LifecycleMixin, ProfileSwitchMixin {
  late final PageController pageController;

  @override
  AccountPageViewModelState build() {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final Profile? profile = profileController.currentProfile;
    pageController = PageController(
      initialPage: (profile?.featureFlags.contains(kFeatureFlagOrganisation) ?? true) ? 1 : 0,
    );
    return AccountPageViewModelState.initialState();
  }

  void onProfileChange(int profileIndex, ProfileControllerState profileState, ProfileSwitchMixin mixin) {
    final Profile targetProfile = mixin.getSupportedProfiles()[profileIndex];
    final bool isOrganisation = targetProfile.featureFlags.contains(kFeatureFlagOrganisation);
    final Color accentColour = targetProfile.accentColor.toSafeColorFromHex();

    final int targetPage = (isOrganisation ? 1 : 0);

    switch (isOrganisation) {
      case true:
        state = state.copyWith(
          organisationAccentColour: accentColour,
        );
        break;
      default:
        state = state.copyWith(
          profileAccentColour: accentColour,
        );
    }

    pageController.animateToPage(
      targetPage,
      duration: kAnimationDurationExtended,
      curve: Curves.easeInOut,
    );
  }

  @override
  void onFirstRender() {
    super.onFirstRender();
    prepareProfileSwitcher();

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final Profile? profile = profileController.currentProfile;

    state = state.copyWith(
      organisationAccentColour: profile?.accentColor.toColorFromHex() ?? Colors.white,
      profileAccentColour: profile?.accentColor.toColorFromHex() ?? Colors.white,
    );
  }

}
