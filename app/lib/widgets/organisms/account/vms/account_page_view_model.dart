// Package imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
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

@Riverpod(keepAlive: true)
class AccountPageViewModel extends _$AccountPageViewModel with LifecycleMixin, ProfileSwitchMixin {
  final PageController pageController = PageController();

  @override
  AccountPageViewModelState build() {
    return AccountPageViewModelState.initialState();
  }

  void onProfileChange(int profileIndex, ProfileControllerState profileState, ProfileSwitchMixin mixin) {
    final Profile targetProfile = mixin.getSupportedProfiles()[profileIndex];
    final bool isOrganisation = targetProfile.featureFlags.contains("organisation");
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
  }
}
