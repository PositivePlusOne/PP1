// Flutter imports:
import 'package:app/providers/content/reactions_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/molecules/content/reaction_options_dialog.dart';
import 'package:app/widgets/organisms/profile/dialogs/reaction_modal_dialog.dart';
import 'package:app/widgets/state/positive_reactions_state.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/molecules/content/post_options_dialog.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:unicons/unicons.dart';

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

    if (currentProfileId.isNotEmpty && currentProfileId == targetProfileId) {
      await PositiveDialog.show(
        title: '',
        context: context,
        barrierDismissible: true,
        child: CommentOptionsDialog(
          onDeleteCommentSelected: () => onPostDeleted(
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
          ReactionModalDialogOptionType.message,
          ReactionModalDialogOptionType.block,
          if (reactionID.isNotEmpty) ReactionModalDialogOptionType.reportReaction,
        },
      ),
    );
  }

  Future<void> onPostDeleted({
    required BuildContext context,
    required Profile? currentProfile,
    required PositiveReactionsState reactionFeedState,
  }) async {
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final AppRouter router = providerContainer.read(appRouterProvider);

    await router.pop();
    await PositiveDialog.show(
      title: localisations.post_dialogue_delete_post,
      context: context,
      barrierDismissible: true,
      child: PostDeleteConfirmDialog(
        onDeletePostConfirmed: () => onPostDeleteConfirmed(
          context: context,
          currentProfile: currentProfile,
          reactionFeedState: reactionFeedState,
        ),
      ),
    );
  }

  Future<void> onPostDeleteConfirmed({
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
        title: localisations.post_dialogue_delete_post_fail,
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
      title: localisations.post_dialogue_delete_post_success,
      icon: UniconsLine.file_times_alt,
      backgroundColour: colours.black,
    );

    if (router.navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(router.navigatorKey.currentContext!).showSnackBar(snackBar);
    }

    await router.pop();
  }
}
