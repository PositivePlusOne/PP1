// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/color_extensions.dart';
import 'package:app/extensions/profile_extensions.dart';
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

@riverpod
class AccountPageViewModel extends _$AccountPageViewModel with LifecycleMixin, ProfileSwitchMixin {
  @override
  AccountPageViewModelState build() {
    return AccountPageViewModelState.initialState();
  }

  void onProfileChange(int profileIndex, ProfileSwitchMixin mixin) {
    final Profile targetProfile = mixin.getSupportedProfiles()[profileIndex];
    final bool isOrganisation = targetProfile.isOrganisation;
    final Color accentColour = targetProfile.accentColor.toSafeColorFromHex();

    mixin.switchProfile(targetProfile.flMeta?.id ?? '');

    switch (isOrganisation) {
      case true:
        state = state.copyWith(organisationAccentColour: accentColour);
        break;
      default:
        state = state.copyWith(profileAccentColour: accentColour);
    }
  }

  @override
  void onFirstRender() {
    super.onFirstRender();
    prepareProfileSwitcher();

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final Profile? profile = profileController.currentProfile;

    state = state.copyWith(
      organisationAccentColour: profile?.accentColor.toSafeColorFromHex() ?? Colors.white,
      profileAccentColour: profile?.accentColor.toSafeColorFromHex() ?? Colors.white,
    );
  }
}
