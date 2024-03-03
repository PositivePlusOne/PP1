import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/helpers/cache_helpers.dart';
import 'package:app/hooks/cache_hook.dart';
import 'package:app/providers/content/reactions_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_close_button.dart';
import 'package:app/widgets/atoms/buttons/positive_invisible_icon_button.dart';
import 'package:app/widgets/behaviours/positive_reaction_pagination_behaviour.dart';
import 'package:app/widgets/molecules/navigation/positive_app_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/state/positive_reactions_state.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class PostReactionsPage extends StatefulHookConsumerWidget {
  const PostReactionsPage({
    required this.activity,
    required this.feed,
    required this.reactionType,
    super.key,
  });

  final Activity activity;
  final TargetFeed feed;
  final String reactionType;

  @override
  ConsumerState<PostReactionsPage> createState() => _PostReactionsPageState();
}

class _PostReactionsPageState extends ConsumerState<PostReactionsPage> {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaData = MediaQuery.of(context);

    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final ReactionsController reactionsController = ref.read(reactionsControllerProvider.notifier);
    final CacheController cacheController = ref.read(cacheControllerProvider);

    final ProfileControllerState profileState = ref.watch(profileControllerProvider);

    final String activityId = widget.activity.publisherInformation?.publisherId ?? '';
    final String activityOrigin = TargetFeed.toOrigin(widget.feed);

    final Profile? currentProfile = profileState.currentProfile;
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';

    final String publisherId = widget.activity.publisherInformation?.publisherId ?? '';
    final String expectedTargetRelationshipKey = [currentProfileId, publisherId].asGUID;
    final Relationship? targetRelationship = cacheController.get(expectedTargetRelationshipKey);

    final String expectedReactionsKey = PositiveReactionsState.buildReactionsCacheKey(activityId: activityId, profileId: currentProfileId, activityOrigin: activityOrigin);
    PositiveReactionsState? reactionsState = cacheController.get(expectedReactionsKey);
    reactionsState ??= PositiveReactionsState.createNewFeedState(activityId: activityId, activityOrigin: activityOrigin, profileId: currentProfileId);

    final List<String> expectedUniqueReactionKeys = reactionsController.buildExpectedUniqueReactionKeysForActivityAndProfile(activity: widget.activity, currentProfile: currentProfile);
    final List<Reaction> uniqueActivityReactions = cacheController.list(expectedUniqueReactionKeys);

    final List<String> expectedCacheKeys = buildExpectedCacheKeysFromObjects(currentProfile, [widget.activity, reactionsState, ...uniqueActivityReactions]).toList();
    useCacheHook(keys: expectedCacheKeys);

    return PositiveScaffold(
      appBar: PositiveAppBar(
        safeAreaQueryData: mediaData,
        applyLeadingandTrailingPadding: true,
        leading: const PositiveCloseButton(),
        trailing: const <Widget>[
          PositiveInvisibleButton(),
        ],
        centerTitle: true,
        title: 'Liked by',
        titleStyle: typography.styleHeroMedium,
      ),
      headingWidgets: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              Container(height: kPaddingExtraSmall, color: colors.colorGray1),
              PositiveReactionPaginationBehaviour(
                kind: widget.reactionType,
                activity: widget.activity,
                publisherRelationship: targetRelationship,
                reactionsState: reactionsState,
                feed: widget.feed,
                reactionMode: widget.activity.securityConfiguration?.commentMode,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
