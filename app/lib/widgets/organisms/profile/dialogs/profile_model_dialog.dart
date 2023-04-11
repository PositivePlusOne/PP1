// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/user/user_profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';
import '../../../../providers/system/design_controller.dart';

enum ProfileModalDialogOptions {
  viewProfile,
  follow,
  connect,
  message,
  block,
  report,
}

class ProfileModalDialog extends ConsumerStatefulWidget {
  const ProfileModalDialog({
    required this.userProfile,
    this.options = const {
      ProfileModalDialogOptions.viewProfile,
      ProfileModalDialogOptions.follow,
      ProfileModalDialogOptions.connect,
      ProfileModalDialogOptions.message,
      ProfileModalDialogOptions.block,
      ProfileModalDialogOptions.report,
    },
    super.key,
  });

  final UserProfile userProfile;
  final Set<ProfileModalDialogOptions> options;

  @override
  ProfileModalDialogState createState() => ProfileModalDialogState();
}

class ProfileModalDialogState extends ConsumerState<ProfileModalDialog> {
  bool _isBusy = false;

  Future<void> onOptionSelected(ProfileModalDialogOptions option) async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isBusy = true;
    });

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final String userId = widget.userProfile.flMeta?.id ?? '';
    final bool isBlocked = profileController.state.blockedUsers.contains(widget.userProfile.flMeta?.id ?? '');

    if (userId.isEmpty) {
      return;
    }

    try {
      switch (option) {
        case ProfileModalDialogOptions.viewProfile:
          await ref.read(profileControllerProvider.notifier).viewProfile(widget.userProfile);
          break;
        case ProfileModalDialogOptions.follow:
          break;
        case ProfileModalDialogOptions.connect:
          break;
        case ProfileModalDialogOptions.message:
          break;
        case ProfileModalDialogOptions.block:
          isBlocked ? await ref.read(profileControllerProvider.notifier).unblockUser(userId) : await ref.read(profileControllerProvider.notifier).blockUser(userId);
          break;
        case ProfileModalDialogOptions.report:
          break;
      }
    } finally {
      setState(() {
        _isBusy = false;
      });
    }
  }

  Widget buildOption(BuildContext context, ProfileModalDialogOptions option) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    final bool isBlocked = profileController.state.blockedUsers.contains(widget.userProfile.flMeta?.id ?? '');

    buttonFromOption(ProfileModalDialogOptions option, IconData? icon, String label) => PositiveButton(
          colors: colors,
          primaryColor: colors.black,
          label: label,
          icon: icon,
          onTapped: () => onOptionSelected(option),
          isDisabled: _isBusy,
        );

    switch (option) {
      case ProfileModalDialogOptions.viewProfile:
        return buttonFromOption(option, UniconsLine.user_circle, localizations.shared_profile_modal_action_view_profile);
      case ProfileModalDialogOptions.follow:
        return buttonFromOption(option, UniconsLine.plus_circle, localizations.shared_profile_modal_action_follow);
      case ProfileModalDialogOptions.connect:
        return buttonFromOption(option, UniconsLine.user_plus, localizations.shared_profile_modal_action_connect);
      case ProfileModalDialogOptions.message:
        return buttonFromOption(option, UniconsLine.envelope, localizations.shared_profile_modal_action_message);
      case ProfileModalDialogOptions.block:
        return buttonFromOption(option, UniconsLine.ban, isBlocked ? localizations.shared_profile_modal_action_unblock : localizations.shared_profile_modal_action_block);
      case ProfileModalDialogOptions.report:
        return buttonFromOption(option, UniconsLine.exclamation_circle, localizations.shared_profile_modal_action_report);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = widget.options.map((option) => buildOption(context, option)).toList();
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(kPaddingSmall),
      child: PositiveGlassSheet(
        onDismissRequested: () => Navigator.of(context).pop(),
        children: children.spaceWithVertical(kPaddingMedium),
      ),
    );
  }
}
