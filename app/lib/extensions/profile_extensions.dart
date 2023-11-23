// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/database/relationships/relationship_member.dart';
import 'package:app/extensions/dart_extensions.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/company_sectors_controller.dart';
import 'package:app/providers/profiles/gender_controller.dart';
import 'package:app/providers/profiles/hiv_status_controller.dart';
import 'package:app/providers/profiles/interests_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/positive_notifications_button.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
import 'package:app/widgets/organisms/profile/vms/profile_view_model.dart';
import '../constants/profile_constants.dart';
import '../dtos/database/profile/profile.dart';
import '../helpers/profile_helpers.dart';
import '../providers/profiles/profile_controller.dart';

extension ProfileExtensions on Profile {
  Media? get profileImage {
    return media.firstWhereOrNull((element) => element.bucketPath.contains('/profile'));
  }

  Media? get coverImage {
    return media.firstWhereOrNull((element) => element.bucketPath.contains('/cover'));
  }

  Media? get referenceImage {
    return media.firstWhereOrNull((element) => element.bucketPath.contains('private/reference'));
  }

  bool get hasPromotionsEnabled {
    return availablePromotionsCount > 0 || activePromotionsCount > 0;
  }

  bool get isOwned {
    return flMeta?.ownedBy?.isNotEmpty == true;
  }

  bool get hasDirectoryEntry {
    return flMeta?.directoryEntryId.isNotEmpty ?? false;
  }

  String? get directoryEntryId {
    return flMeta?.directoryEntryId;
  }

  String getSafeDisplayName(AppLocalizations localizations) {
    if (displayName.isEmpty || isIncognito) {
      return localizations.shared_placeholders_empty_display_name;
    }

    return displayName.asHandle;
  }

  bool isCurrentlyOwnedByUser() {
    final UserControllerState userControllerState = providerContainer.read(userControllerProvider);
    final String profileID = flMeta?.id ?? '';
    if (profileID.isEmpty || userControllerState.currentClaims.isEmpty) {
      return false;
    }

    final Map<String, dynamic> claims = userControllerState.currentClaims;
    final List<dynamic> managedProfiles = claims['managedProfiles'] ?? [];
    final bool isManaged = managedProfiles.contains(profileID);

    return isManaged;
  }

  bool matchesStringSearch(String str) {
    final String lowerCaseName = name.toLowerCase();
    final String lowerCaseDisplayName = displayName.toLowerCase();
    final String lowerCaseSearchString = str.toLowerCase();

    return lowerCaseName.contains(lowerCaseSearchString) || lowerCaseDisplayName.contains(lowerCaseSearchString);
  }

  bool canDisplayOnFeed({
    required Relationship? relationship,
  }) {
    final String targetProfileId = flMeta?.id ?? '';
    if (targetProfileId.isEmpty) {
      return false;
    }

    final RelationshipMember? targetRelationshipMember = relationship?.members.firstWhereOrNull((element) => element.memberId == targetProfileId);
    if (targetRelationshipMember == null) {
      return true;
    }

    final bool isBlockedByTarget = targetRelationshipMember.hasBlocked;
    final bool isTargetIncognito = featureFlags.contains(kFeatureFlagIncognito);

    if (isBlockedByTarget || isTargetIncognito) {
      return false;
    }

    return true;
  }

  List<Widget> buildCommonProfilePageActions({
    bool disableNotifications = false,
    bool disableAccount = false,
    bool includeSpacer = false,
    Color? color,
    Color? ringColorOverrideProfile,
    Color? badgeColorOverride,
    void Function()? onTapNotifications,
    void Function()? onTapProfile,
  }) {
    final List<Widget> children = [];
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final NotificationsController notificationsController = providerContainer.read(notificationsControllerProvider.notifier);
    final bool isUserProfile = profileController.isCurrentlyUserProfile;

    if (profileController.hasSetupProfile) {
      children.addAll([
        PositiveNotificationsButton(
          color: color,
          isDisabled: disableNotifications,
          includeBadge: isUserProfile && notificationsController.canDisplayNotificationFeedBadge,
          badgeColor: badgeColorOverride,
          onTap: onTapNotifications,
        ),
        if (includeSpacer) const SizedBox(width: kPaddingSmall),
        PositiveProfileCircularIndicator(
          profile: profileController.currentProfile,
          isEnabled: !disableAccount,
          onTap: onTapProfile ?? onProfileAccountActionSelected,
          ringColorOverride: ringColorOverrideProfile,
        ),
      ]);
    }

    return children;
  }

  Map<String, bool> buildFormVisibilityFlags({bool isLoadedProfile = false}) {
    final Map<String, bool> newVisibilityFlags = {};
    for (final String flag in visibilityFlags) {
      newVisibilityFlags[flag] = true;
    }

    for (final String flag in kDefaultVisibilityFlags.keys) {
      if (newVisibilityFlags.containsKey(flag)) {
        continue;
      }
      newVisibilityFlags[flag] = isLoadedProfile ? false : kDefaultVisibilityFlags[flag] ?? false;
    }

    return newVisibilityFlags;
  }

  Map<String, bool> buildFormFeatureFlags() {
    return {
      kFeatureFlagMarketing: featureFlags.contains(kFeatureFlagMarketing),
    };
  }

  bool get isVerified {
    return featureFlags.contains(kFeatureFlagVerified);
  }

  String get nameRespectingFlags {
    final bool shouldIgnore = !visibilityFlags.contains(kVisibilityFlagName);
    if (shouldIgnore) {
      return '';
    }

    return name;
  }

  int get age {
    if (birthday.isEmpty) {
      return 0;
    }

    return DateTime.now().difference(DateTime.parse(birthday)).inDays ~/ 365;
  }

  String get formattedAgeRespectingFlags {
    final bool shouldIgnore = !visibilityFlags.contains(kVisibilityFlagBirthday);
    if (shouldIgnore) {
      return '';
    }

    return age.toString();
  }

  /// small function to return if this profile is the profile of an organisation - as taken
  /// from the featureFlags data - does it contain the entry 'organisation'
  bool get isOrganisation => featureFlags.contains(kFeatureFlagOrganisation);

  bool get isPendingDeletion => accountFlags.contains(kFeatureFlagPendingDeletion);

  /// Checks the following properties, and comma seperates them if they are not empty and the visibility flag is set to true
  // String getTagline(AppLocalizations localizations) {
  //   final List<String> taglineParts = [];
  //   final HivStatusControllerState hivControllerState = providerContainer.read(hivStatusControllerProvider);
  //   final GenderControllerState genderControllerState = providerContainer.read(genderControllerProvider);
  //   final CompanySectorsControllerState companySectorsControllerState = providerContainer.read(companySectorsControllerProvider);

  //   if (birthday.isNotEmpty && !isOrganisation) {
  //     taglineParts.add('$age');
  //   }

  //   if (companySectors.isNotEmpty && isOrganisation) {
  //     // show the company's sector(s)
  //     for (final String companySector in companySectors) {
  //       if (!companySectorsControllerState.options.any((element) => element.value == companySector)) {
  //         continue;
  //       }

  //       taglineParts.add(companySectorsControllerState.options.firstWhere((element) => element.value == companySector).label);
  //     }
  //   }

  //   if (place != null && place!.description.isNotEmpty) {
  //     taglineParts.add(place!.description);
  //   }

  //   if (hivStatus.isNotEmpty && !isOrganisation) {
  //     for (var status in hivControllerState.hivStatuses) {
  //       if (status.children == null) continue;

  //       for (var element in status.children!) {
  //         if (element.value == hivStatus) {
  //           taglineParts.add(element.label);
  //           break;
  //         }
  //       }
  //     }
  //   }

  //   if (genders.isNotEmpty && !isOrganisation) {
  //     for (final String gender in genders) {
  //       if (!genderControllerState.options.any((element) => element.value == gender)) {
  //         continue;
  //       }

  //       taglineParts.add(genderControllerState.options.firstWhere((element) => element.value == gender).label);
  //     }
  //   }

  //   if (taglineParts.isEmpty) {
  //     return localizations.shared_profile_tagline;
  //   }

  //   return taglineParts.join(', ');
  // }

  String get formattedGenderIgnoreFlags {
    final List<String> taglineParts = [];
    final GenderControllerState genderControllerState = providerContainer.read(genderControllerProvider);

    for (final String gender in genders) {
      if (!genderControllerState.options.any((element) => element.value == gender)) {
        continue;
      }

      taglineParts.add(genderControllerState.options.firstWhere((element) => element.value == gender).label);
    }

    return taglineParts.join(', ');
  }

  String get formattedGenderRespectingFlags {
    final bool shouldIgnore = !visibilityFlags.contains(kVisibilityFlagGenders);
    if (shouldIgnore) {
      return '';
    }

    return formattedGenderIgnoreFlags;
  }

  String get formattedHIVStatusRespectingFlags {
    final bool shouldIgnore = !visibilityFlags.contains(kVisibilityFlagHivStatus);
    if (shouldIgnore) {
      return '';
    }

    return formattedHIVStatus;
  }

  String get formattedInterestsRespectingFlags {
    final bool shouldIgnore = !visibilityFlags.contains(kVisibilityFlagInterests);
    if (shouldIgnore) {
      return '';
    }

    final InterestsController interestsController = providerContainer.read(interestsControllerProvider.notifier);
    final List<String> knownInterests = [];

    for (final String interest in interests) {
      if (!interestsController.state.interests.containsKey(interest)) {
        continue;
      }

      knownInterests.add(interestsController.state.interests[interest] ?? '');
    }

    return knownInterests.join(', ');
  }

  String get formattedCompanySectorsIgnoreFlags {
    final List<String> taglineParts = [];
    final CompanySectorsControllerState companySectorsControllerState = providerContainer.read(companySectorsControllerProvider);

    for (final String companySector in companySectors) {
      if (!companySectorsControllerState.options.any((element) => element.value == companySector)) {
        continue;
      }

      taglineParts.add(companySectorsControllerState.options.firstWhere((element) => element.value == companySector).label);
    }

    return taglineParts.join(', ');
  }

  String get formattedHIVStatus {
    final HivStatusControllerState hivController = providerContainer.read(hivStatusControllerProvider);

    for (final HivStatus status in hivController.hivStatuses) {
      if (status.children != null) {
        for (final HivStatus subStatus in status.children ?? []) {
          if (subStatus.value == hivStatus) {
            return subStatus.label;
          }
        }
      }
    }

    return '';
  }

  bool get isLocationAvailable => place?.description.isNotEmpty ?? false;

  String get formattedLocation {
    final AppRouter appRouter = providerContainer.read(appRouterProvider);
    final BuildContext context = appRouter.navigatorKey.currentContext!;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    if (!isLocationAvailable) {
      return localizations.shared_profile_unknown_location;
    }

    return place!.description;
  }

  String get formattedLocationRespectingFlags {
    final bool shouldIgnore = !visibilityFlags.contains(kVisibilityFlagLocation);
    if (shouldIgnore) {
      return '';
    }

    return formattedLocation;
  }

  bool get hasMarketingFeature {
    return featureFlags.contains(kFeatureFlagMarketing);
  }

  bool get isIncognito {
    return visibilityFlags.contains(kFeatureFlagIncognito);
  }

  Future<void> navigateToProfile() async {
    final AppRouter appRouter = providerContainer.read(appRouterProvider);
    final Logger logger = providerContainer.read(loggerProvider);

    final String targetProfileId = flMeta?.id ?? '';
    if (targetProfileId.isEmpty) {
      logger.e('onViewProfileButtonSelected: currentProfileId is empty');
      return;
    }

    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final String currentProfileId = profileController.currentProfileId ?? '';
    if (currentProfileId.isNotEmpty) {
      final CacheController cacheController = providerContainer.read(cacheControllerProvider);
      final Relationship? relationship = cacheController.get([currentProfileId, targetProfileId].asGUID);
      final Set<RelationshipState> relationshipStates = relationship?.relationshipStatesForEntity(currentProfileId) ?? {};
      final bool isBlockedByTarget = relationshipStates.contains(RelationshipState.targetBlocked);
      if (isBlockedByTarget) {
        logger.e('onViewProfileButtonSelected: target profile is blocked');
        return;
      }
    }

    final ProfileViewModel profileViewModel = providerContainer.read(profileViewModelProvider.notifier);
    await profileViewModel.preloadUserProfile(targetProfileId);

    await appRouter.push(const ProfileRoute());
  }

  Future<void> navigateToProfileDetails() async {
    final AppRouter appRouter = providerContainer.read(appRouterProvider);
    final Logger logger = providerContainer.read(loggerProvider);

    final String targetProfileId = flMeta?.id ?? '';
    if (targetProfileId.isEmpty) {
      logger.e('onViewProfileButtonSelected: currentProfileId is empty');
      return;
    }

    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final String currentProfileId = profileController.currentProfileId ?? '';
    if (currentProfileId.isNotEmpty) {
      final CacheController cacheController = providerContainer.read(cacheControllerProvider);
      final Relationship? relationship = cacheController.get([currentProfileId, targetProfileId].asGUID);
      final Set<RelationshipState> relationshipStates = relationship?.relationshipStatesForEntity(currentProfileId) ?? {};
      final bool isBlockedByTarget = relationshipStates.contains(RelationshipState.targetBlocked);
      if (isBlockedByTarget) {
        logger.e('onViewProfileButtonSelected: target profile is blocked');
        return;
      }
    }

    final ProfileViewModel profileViewModel = providerContainer.read(profileViewModelProvider.notifier);
    await profileViewModel.preloadUserProfile(targetProfileId);

    await appRouter.push(const ProfileDetailsRoute());
  }
}

extension ProfileStatisticsExtensions on ProfileStatistics {
  /// Accessors for the data which is in a nasty little map (gets the data from the map and defaults to zero)
  int get posts => counts[ProfileStatistics.kPostKey] ?? 0;
  int get likes => counts[ProfileStatistics.kLikeKey] ?? 0;
  int get shares => counts[ProfileStatistics.kShareKey] ?? 0;
  int get followers => counts[ProfileStatistics.kFollowersKey] ?? 0;
  int get following => counts[ProfileStatistics.kFollowingKey] ?? 0;

  /// a nice accessor for the data which is in a nasty little map (gets the data from the map and defaults to -1 which is the error (never permitted) case)
  int get promotionsPermitted => counts[ProfileStatistics.kPromotionsPermittedKey] ?? ProfileStatistics.kPromotionsNotPermitted;
}
