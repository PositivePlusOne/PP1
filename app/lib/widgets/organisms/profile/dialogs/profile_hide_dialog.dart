// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fluent_validation/fluent_validation.dart';
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
import 'package:app/helpers/cache_helpers.dart';
import 'package:app/hooks/cache_hook.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/organisms/account/vms/account_view_model.dart';
import '../../../../providers/system/design_controller.dart';

class ProfileHideDialog extends HookConsumerWidget {
  const ProfileHideDialog({
    required this.targetProfileId,
    required this.currentProfileId,
    super.key,
  });

  final String targetProfileId;
  final String currentProfileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final AccountViewModelProvider viewModelProvider = accountViewModelProvider.call(const FeedbackType.userReport());
    final AccountViewModel viewModel = ref.read(viewModelProvider.notifier);
    final AccountViewModelState state = ref.watch(viewModelProvider);

    final ValidationResult validationResults = viewModel.feedbackValidator.validate(state.feedback);
    final bool isValid = validationResults.hasError == false;

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final CacheController cacheController = ref.read(cacheControllerProvider);

    final Profile? currentProfile = cacheController.get(currentProfileId);
    final Profile? targetProfile = cacheController.get(targetProfileId);

    final List<String> expectedCacheKeys = buildExpectedCacheKeysForProfile(currentProfile, targetProfile ?? Profile.empty());
    useCacheHook(keys: expectedCacheKeys);

    return Column(
      children: <Widget>[
        Text(
          localizations.shared_profile_hide_body(targetProfile?.displayName.asHandle ?? ''),
          style: typography.styleSubtitle.copyWith(color: colors.white),
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          onTapped: () => viewModel.onHidePostsRequested(targetProfile: targetProfile),
          icon: UniconsLine.eye,
          label: localizations.shared_profile_hide_action(targetProfile?.displayName.asHandle ?? ''),
          primaryColor: colors.white,
          style: PositiveButtonStyle.primary,
          isDisabled: state.isBusy,
        ),
        const SizedBox(height: kPaddingMedium),
        PositiveButton(
          colors: colors,
          onTapped: () => Navigator.pop(context),
          label: localizations.shared_actions_cancel,
          primaryColor: colors.black,
          style: PositiveButtonStyle.primary,
          isDisabled: state.isBusy,
        ),
      ],
    );
  }
}
