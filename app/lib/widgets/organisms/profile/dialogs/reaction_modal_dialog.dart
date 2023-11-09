// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/helpers/cache_helpers.dart';
import 'package:app/hooks/cache_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/user/get_stream_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/organisms/profile/dialogs/profile_block_dialog.dart';
import 'package:app/widgets/organisms/profile/dialogs/profile_unblock_dialog.dart';
import 'package:app/widgets/organisms/profile/dialogs/reaction_report_dialog.dart';
import '../../../../../providers/system/design_controller.dart';
import '../../../../gen/app_router.dart';
import '../../../molecules/dialogs/positive_dialog.dart';

// Project imports:

enum ReactionModalDialogOptionType {
  message(1),
  block(2),
  reportReaction(3);

  const ReactionModalDialogOptionType([this.order = 0]);

  final int order;
}

class ReactionModalDialogOption {
  const ReactionModalDialogOption({
    required this.icon,
    required this.title,
    this.primaryColor = Colors.black,
    this.isDisabled = false,
  });

  final IconData icon;
  final String title;

  final Color primaryColor;
  final bool isDisabled;
}

class ReactionModalDialog extends StatefulHookConsumerWidget {
  const ReactionModalDialog({
    required this.targetProfileId,
    required this.currentProfileId,
    required this.reactionID,
    this.styleOverrides = const {},
    this.types,
    super.key,
  });

  final String currentProfileId;
  final String targetProfileId;
  final String reactionID;

  final Map<ReactionModalDialogOptionType, ReactionModalDialogOption> styleOverrides;
  final Set<ReactionModalDialogOptionType>? types;
  static const String kProfileDialogHeroTag = 'reaction_modal_dialog';

  @override
  ConsumerState<ReactionModalDialog> createState() => _ReactionModalDialogState();
}

class _ReactionModalDialogState extends ConsumerState<ReactionModalDialog> {
  bool isBusy = false;
  Future<void> onOptionSelected({
    required ReactionModalDialogOptionType type,
    required Profile? currentProfile,
    required Profile targetProfile,
    required Relationship? targetRelationship,
  }) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final BuildContext context = appRouter.navigatorKey.currentContext!;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final String targetProfileId = targetProfile.flMeta?.id ?? '';
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';

    if (!mounted || targetProfileId.isEmpty) {
      return;
    }

    setState(() {
      isBusy = true;
    });

    final GetStreamController getStreamController = ref.read(getStreamControllerProvider.notifier);
    final Set<RelationshipState> relationshipStates = targetRelationship?.relationshipStatesForEntity(currentProfileId) ?? {};

    final String targetDisplayNameHandle = targetProfile.displayName.asHandle;

    try {
      switch (type) {
        case ReactionModalDialogOptionType.message:
          await getStreamController.createConversation([targetProfileId], shouldPopDialog: true);
          break;
        case ReactionModalDialogOptionType.block:
          final bool hasSourceBlocked = relationshipStates.contains(RelationshipState.sourceBlocked);
          if (!hasSourceBlocked) {
            await appRouter.pop();
            await PositiveDialog.show(
              context: context,
              useSafeArea: false,
              title: localizations.shared_profile_modal_action_block(targetDisplayNameHandle),
              child: ProfileBlockDialog(
                targetProfileId: targetProfileId,
                currentProfileId: currentProfileId,
              ),
            );
          } else {
            await appRouter.pop();
            await PositiveDialog.show(
              context: context,
              useSafeArea: false,
              title: localizations.shared_profile_modal_action_block(targetDisplayNameHandle),
              child: ProfileUnblockDialog(
                targetProfileId: targetProfileId,
                currentProfileId: currentProfileId,
              ),
            );
          }
          break;
        case ReactionModalDialogOptionType.reportReaction:
          if (widget.reactionID.isEmpty) {
            await appRouter.pop();
            break;
          }

          await appRouter.pop();
          await PositiveDialog.show(
            context: context,
            useSafeArea: false,
            title: localizations.comment_report_dialog_title,
            child: ReactionReportDialog(
              reactionID: widget.reactionID,
              currentProfile: currentProfile,
              targetProfile: targetProfile,
            ),
          );
          break;
      }
    } finally {
      if (mounted) {
        setState(() => isBusy = false);
      }
    }
  }

  Widget buildOption({
    required Profile? currentProfile,
    required Profile targetProfile,
    required Relationship? targetRelationship,
    required AppLocalizations localizations,
    required DesignColorsModel colors,
    required ReactionModalDialogOptionType type,
  }) {
    final String targetProfileId = targetProfile.flMeta?.id ?? '';
    final String targetProfileDisplayNameHandle = targetProfile.displayName.asHandle;
    if (targetProfileId.isEmpty) {
      return const SizedBox.shrink();
    }

    final Set<RelationshipState> relationshipStates = targetRelationship?.relationshipStatesForEntity(currentProfile?.flMeta?.id ?? '') ?? {};
    final bool isSourceBlocked = relationshipStates.contains(RelationshipState.sourceBlocked);

    Widget buttonFromOptionType(ReactionModalDialogOptionType type, IconData? icon, String label, {bool highlightOption = false, bool isDisabled = false}) {
      if (widget.styleOverrides.containsKey(type)) {
        final ReactionModalDialogOption? styleOverride = widget.styleOverrides[type];
        if (styleOverride != null) {
          return PositiveButton(
            colors: colors,
            primaryColor: styleOverride.primaryColor,
            label: styleOverride.title,
            icon: styleOverride.icon,
            forceIconPadding: true,
            onTapped: () => onOptionSelected(
              type: type,
              currentProfile: currentProfile,
              targetProfile: targetProfile,
              targetRelationship: targetRelationship,
            ),
            isDisabled: isBusy || styleOverride.isDisabled,
          );
        }
      }

      return PositiveButton(
        colors: colors,
        primaryColor: highlightOption ? colors.yellow : colors.black,
        label: label,
        icon: icon,
        forceIconPadding: true,
        onTapped: () => onOptionSelected(
          type: type,
          currentProfile: currentProfile,
          targetProfile: targetProfile,
          targetRelationship: targetRelationship,
        ),
        isDisabled: isBusy || isDisabled,
      );
    }

    switch (type) {
      case ReactionModalDialogOptionType.message:
        return buttonFromOptionType(type, UniconsLine.envelope, localizations.shared_profile_modal_action_message(targetProfileDisplayNameHandle));
      case ReactionModalDialogOptionType.block:
        return buttonFromOptionType(type, UniconsLine.ban, isSourceBlocked ? localizations.shared_profile_modal_action_unblock(targetProfileDisplayNameHandle) : localizations.shared_profile_modal_action_block(targetProfileDisplayNameHandle), highlightOption: isSourceBlocked);
      case ReactionModalDialogOptionType.reportReaction:
        return buttonFromOptionType(type, UniconsLine.exclamation_circle, localizations.shared_profile_modal_action_report_comment);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));

    final CacheController cacheController = ref.read(cacheControllerProvider);
    final ProfileControllerState profileControllerState = ref.watch(profileControllerProvider);
    final Profile? currentProfile = profileControllerState.currentProfile;
    final Profile? targetProfile = cacheController.get(widget.targetProfileId);

    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    final String targetProfileId = targetProfile?.flMeta?.id ?? '';
    final String relationshipId = [currentProfileId, targetProfileId].asGUID;
    final Relationship? targetRelationship = cacheController.get(relationshipId);

    final List<Widget> children = [];
    final List<ReactionModalDialogOptionType> optionTypes = [];

    if (widget.types != null) {
      optionTypes.addAll(widget.types!);
    }

    final List<String> expectedCacheKeys = buildExpectedCacheKeysForProfile(currentProfile, targetProfile ?? Profile.empty());
    useCacheHook(keys: expectedCacheKeys);

    // Order the options based on the order of the types
    optionTypes.sort((a, b) => a.order.compareTo(b.order));

    for (final ReactionModalDialogOptionType optionType in optionTypes) {
      if (targetProfile == null) {
        continue;
      }

      final option = buildOption(
        colors: colors,
        currentProfile: currentProfile,
        localizations: localizations,
        targetProfile: targetProfile,
        targetRelationship: targetRelationship,
        type: optionType,
      );

      children.add(option);
    }

    return Column(
      children: children.spaceWithVertical(kPaddingMedium),
    );
  }
}
