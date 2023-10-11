// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/profile_extensions.dart';
import 'package:app/helpers/brand_helpers.dart';
import 'package:app/hooks/cache_hook.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/communities_controller.dart';
import 'package:app/widgets/atoms/input/positive_text_field_dropdown.dart';
import 'package:app/widgets/behaviours/positive_notification_pagination_behaviour.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:app/widgets/molecules/dialogs/positive_communities_dialog.dart';
import 'package:app/widgets/molecules/layouts/positive_basic_sliver_list.dart';
import 'package:app/widgets/molecules/navigation/positive_navigation_bar.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/molecules/switchers/positive_profile_segmented_switcher.dart';
import 'package:app/widgets/organisms/notifications/vms/notifications_view_model.dart';
import 'package:app/widgets/state/positive_notifications_state.dart';

@RoutePage()
class NotificationsPage extends HookConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final CacheController cacheController = ref.read(cacheControllerProvider);

    final NotificationsViewModel viewModel = ref.read(notificationsViewModelProvider.notifier);
    ref.watch(notificationsViewModelProvider);

    final Profile? currentProfile = ref.watch(profileControllerProvider.select((value) => value.currentProfile));

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? currentUser = auth.currentUser;
    final String currentUserUid = currentUser?.uid ?? '';

    final List<Widget> actions = [];
    final List<String> cacheKeys = [];
    bool hasNotifications = false;

    if (currentProfile?.flMeta?.id?.isNotEmpty ?? false) {
      actions.addAll(currentProfile!.buildCommonProfilePageActions(disableNotifications: true));
      final String notificationCacheKey = PositiveNotificationsPaginationBehaviourState.getExpectedCacheKey(currentProfile.flMeta!.id!);
      final PositiveNotificationsState? cachedFeedState = cacheController.get(notificationCacheKey);
      hasNotifications = cachedFeedState?.pagingController.itemList?.isNotEmpty ?? false;
      cacheKeys.add(notificationCacheKey);
    }

    cacheKeys.addAll(viewModel.getSupportedProfileIds());
    ref.watch(profileControllerProvider);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    useCacheHook(keys: cacheKeys);
    useLifecycleHook(viewModel);

    final ProfileControllerState profileState = ref.watch(profileControllerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final List<Profile> supportedProfiles = profileController.availableProfiles;

    final Size screenSize = MediaQuery.of(context).size;

    return PositiveScaffold(
      bottomNavigationBar: PositiveNavigationBar(mediaQuery: mediaQueryData),
      visibleComponents: {
        PositiveScaffoldComponent.headingWidgets,
        if (!hasNotifications) PositiveScaffoldComponent.decorationWidget,
      },
      decorations: !hasNotifications ? buildType3ScaffoldDecorations(colours) : [],
      headingWidgets: <Widget>[
        PositiveBasicSliverList(
          appBarTrailing: actions,
          appBarSpacing: kPaddingNone,
          children: <Widget>[
            // if we can switch profiles - show the profile switcher
            if (viewModel.canSwitchProfile && viewModel.availableProfileCount <= 2) ...<Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: kPaddingSmall),
                child: PositiveProfileSegmentedSwitcher(
                  mixin: viewModel,
                  isSlim: true,
                   useProfileBackgroundColours: true,
                  onTapped: (int profileIndex) => viewModel.switchProfile(viewModel.getSupportedProfileIds()[profileIndex]),
                ),
              ),
            ] else if (viewModel.canSwitchProfile && viewModel.availableProfileCount > 2) ...<Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: kPaddingSmall),
                child: PositiveTapBehaviour(
                  isEnabled: true,
                  onTap: (context) => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return SizedBox(
                        height: screenSize.height,
                        width: screenSize.width,
                        child: PositiveCommunitiesDialog(
                          controllerProvider: communitiesControllerProvider(currentProfile: viewModel.getCurrentProfile(), currentUser: viewModel.getCurrentUser()),
                          supportedCommunityTypes: const [CommunityType.supported],
                          initialCommunityType: CommunityType.supported,
                          mode: CommunitiesDialogMode.select,
                          canCallToAction: false,
                          selectedProfiles: [profileState.currentProfile?.flMeta?.id ?? ''],
                          onProfileSelected: (String id) {
                            viewModel.switchProfile(id);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: IgnorePointer(
                      ignoring: true,
                      child: PositiveTextFieldDropdown<Profile>(
                        labelText: 'Account',
                        values: supportedProfiles,
                        initialValue: profileController.currentProfile ?? supportedProfiles.first,
                        valueComparator: (oldValue, newValue) {
                          if (oldValue is! Profile || newValue is! Profile) {
                            return false;
                          }

                          return oldValue.flMeta?.id == newValue.flMeta?.id;
                        },
                        valueStringBuilder: (value) {
                          final String profileId = value.flMeta?.id ?? '';
                          if (profileId == currentUserUid) {
                            return 'Personal';
                          }

                          return value.displayName;
                        },
                        placeholderStringBuilder: (value) {
                          final String profileId = value.flMeta?.id ?? '';
                          if (profileId == currentUserUid) {
                            return 'Personal';
                          }

                          return value.displayName;
                        },
                        onValueChanged: (type) => viewModel.switchProfile(type.flMeta?.id ?? ''),
                        backgroundColour: colours.white,
                        iconColour: colours.white,
                        iconBackgroundColour: colours.black,
                        borderColour: colours.black,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (currentProfile?.flMeta?.id?.isNotEmpty ?? false) ...<Widget>[
          //TODO: load additional profile notification data after loading first profile
          PositiveNotificationsPaginationBehaviour(
            uid: currentProfile!.flMeta!.id!,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: kPaddingSmall)),
          SliverToBoxAdapter(child: SizedBox(height: PositiveNavigationBar.calculateHeight(mediaQueryData))),
        ],
      ],
    );
  }
}
