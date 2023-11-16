// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logger/logger.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/reactions_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/molecules/content/reaction_options_dialog.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/organisms/profile/dialogs/reaction_modal_dialog.dart';
import 'package:app/widgets/state/positive_reactions_state.dart';

extension ReactionExt on Reaction {
  Future<void> onReactionOptionsSelected({
    required BuildContext context,
    required String reactionID,
    required Profile? targetProfile,
    required Profile? currentProfile,
    required PositiveReactionsState reactionFeedState,
  }) async {
    final String targetProfileId = targetProfile?.flMeta?.id ?? '';
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';

    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final String expectedRelationshipId = [targetProfileId, currentProfileId].asGUID;
    final Relationship? relationship = cacheController.get(expectedRelationshipId);
    final Set<RelationshipState> relationshipStates = relationship?.relationshipStatesForEntity(currentProfileId) ?? {};
    final bool isTargetBlocked = relationshipStates.contains(RelationshipState.targetBlocked);
    final bool isTargetConnected = relationshipStates.contains(RelationshipState.fullyConnected);
    final bool isOrganisationProfile = targetProfile?.featureFlags.contains(kFeatureFlagOrganisation) ?? false;

    if (currentProfileId.isNotEmpty && currentProfileId == targetProfileId) {
      await PositiveDialog.show(
        title: '',
        context: context,
        barrierDismissible: true,
        child: CommentOptionsDialog(
          onDeleteCommentSelected: () => onCommentDeleted(
            context: context,
            currentProfile: currentProfile,
            reactionFeedState: reactionFeedState,
          ),
        ),
      );

      return;
    }

    await PositiveDialog.show(
      context: context,
      useSafeArea: false,
      child: ReactionModalDialog(
        targetProfileId: targetProfileId,
        currentProfileId: currentProfileId,
        reactionID: reactionID,
        types: {
          if (!isTargetBlocked) ...<ReactionModalDialogOptionType>[
            if (isTargetConnected || isOrganisationProfile) ReactionModalDialogOptionType.message,
            ReactionModalDialogOptionType.block,
          ],
          if (reactionID.isNotEmpty) ReactionModalDialogOptionType.reportReaction,
        },
      ),
    );
  }

  Future<void> onCommentDeleted({
    required BuildContext context,
    required Profile? currentProfile,
    required PositiveReactionsState reactionFeedState,
  }) async {
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final AppRouter router = providerContainer.read(appRouterProvider);

    await router.pop();
    await PositiveDialog.show(
      title: localisations.comment_dialogue_delete_comment,
      context: context,
      barrierDismissible: true,
      child: CommentDeleteConfirmDialog(
        onDeleteCommentConfirmed: () => onCommentDeleteConfirmed(
          context: context,
          currentProfile: currentProfile,
          reactionFeedState: reactionFeedState,
        ),
      ),
    );
  }

  Future<void> onCommentDeleteConfirmed({
    required BuildContext context,
    required Profile? currentProfile,
    required PositiveReactionsState reactionFeedState,
  }) async {
    final ReactionsController activityController = providerContainer.read(reactionsControllerProvider.notifier);
    final DesignColorsModel colours = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final AppRouter router = providerContainer.read(appRouterProvider);
    final Logger logger = providerContainer.read(loggerProvider);

    try {
      await activityController.deleteComment(
        comment: this,
        currentProfile: currentProfile,
        feedState: reactionFeedState,
      );
    } catch (e) {
      logger.e("Error deleting comment: $e");

      final PositiveGenericSnackBar snackBar = PositiveGenericSnackBar(
        title: localisations.comment_dialogue_delete_comment_fail,
        icon: UniconsLine.plus_circle,
        backgroundColour: colours.black,
      );

      if (router.navigatorKey.currentContext != null) {
        ScaffoldMessenger.of(router.navigatorKey.currentContext!).showSnackBar(snackBar);
      }

      await router.pop();
      return;
    }

    final PositiveGenericSnackBar snackBar = PositiveGenericSnackBar(
      title: localisations.comment_dialogue_delete_comment_success,
      icon: UniconsLine.file_times_alt,
      backgroundColour: colours.black,
    );

    if (router.navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(router.navigatorKey.currentContext!).showSnackBar(snackBar);
    }

    await router.pop();
  }
}
