// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:app/dtos/database/common/media.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/company_sectors_controller.dart';
import 'package:app/providers/profiles/gender_controller.dart';
import 'package:app/providers/profiles/hiv_status_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_notifications_button.dart';
import 'package:app/widgets/atoms/indicators/positive_profile_circular_indicator.dart';
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

  bool matchesStringSearch(String str) {
    final String lowerCaseName = name.toLowerCase();
    final String lowerCaseDisplayName = displayName.toLowerCase();
    final String lowerCaseSearchString = str.toLowerCase();

    return lowerCaseName.contains(lowerCaseSearchString) || lowerCaseDisplayName.contains(lowerCaseSearchString);
  }

  List<Widget> buildCommonProfilePageActions({bool disableNotifications = false, bool disableAccount = false, Color? color}) {
    final List<Widget> children = [];
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    // final CacheController cacheController = providerContainer.read(cacheControllerProvider);

    // Add notification information
    // int unreadCount = 0;
    // if (profileController.currentProfileId != null) {
    //   final String expectedCacheKey = 'notifications:${profileController.currentProfileId}';
    //   final PositiveNotificationsState? notificationsState = cacheController.get(expectedCacheKey);
    //   if (notificationsState != null) {
    //     unreadCount = notificationsState.unreadCount;
    //   }
    // }

    if (profileController.hasSetupProfile) {
      children.addAll([
        PositiveNotificationsButton(color: color, isDisabled: disableNotifications),
        PositiveProfileCircularIndicator(
          profile: profileController.currentProfile,
          isEnabled: !disableAccount,
          onTap: onProfileAccountActionSelected,
          ringColorOverride: color,
        ),
      ]);
    }

    return children;
  }

  Map<String, bool> buildFormVisibilityFlags() {
    final Map<String, bool> newVisibilityFlags = {
      kVisibilityFlagBirthday: kDefaultVisibilityFlags[kVisibilityFlagBirthday] ?? true,
      kVisibilityFlagInterests: kDefaultVisibilityFlags[kVisibilityFlagInterests] ?? true,
      kVisibilityFlagLocation: kDefaultVisibilityFlags[kVisibilityFlagLocation] ?? true,
      kVisibilityFlagName: kDefaultVisibilityFlags[kVisibilityFlagName] ?? true,
      kVisibilityFlagGenders: kDefaultVisibilityFlags[kVisibilityFlagGenders] ?? true,
      kVisibilityFlagHivStatus: kDefaultVisibilityFlags[kVisibilityFlagHivStatus] ?? true,
      kVisibilityFlagCompanySectors: kDefaultVisibilityFlags[kVisibilityFlagCompanySectors] ?? true,
    };

    final List<(String flag, bool newValue)> overrideFlags = [];
    for (final String flag in visibilityFlags) {
      final bool? newValue = bool.tryParse(flag);
      if (newValue == null) {
        continue;
      }

      overrideFlags.add((flag, newValue));
    }

    for (final (String flag, bool newValue) in overrideFlags) {
      newVisibilityFlags[flag] = newValue;
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

  int get age {
    if (birthday.isEmpty) {
      return 0;
    }

    return DateTime.now().difference(DateTime.parse(birthday)).inDays ~/ 365;
  }

  /// small function to return if this profile is the profile of an organisation - as taken
  /// from the featureFlags data - does it contain the entry 'organisation'
  bool get isOrganisation => featureFlags.contains(kFeatureFlagOrganisation);

  /// Checks the following properties, and comma seperates them if they are not empty and the visibility flag is set to true
  String getTagline(AppLocalizations localizations) {
    final List<String> taglineParts = [];
    final HivStatusControllerState hivControllerState = providerContainer.read(hivStatusControllerProvider);
    final GenderControllerState genderControllerState = providerContainer.read(genderControllerProvider);
    final CompanySectorsControllerState companySectorsControllerState = providerContainer.read(companySectorsControllerProvider);

    if (birthday.isNotEmpty && !isOrganisation) {
      taglineParts.add('$age');
    }

    if (companySectors.isNotEmpty && isOrganisation) {
      // show the company's sector(s)
      for (final String companySector in companySectors) {
        if (!companySectorsControllerState.options.any((element) => element.value == companySector)) {
          continue;
        }

        taglineParts.add(companySectorsControllerState.options.firstWhere((element) => element.value == companySector).label);
      }
    }

    if (place != null && place!.description.isNotEmpty) {
      taglineParts.add(place!.description);
    }

    if (hivStatus.isNotEmpty && !isOrganisation) {
      for (var status in hivControllerState.hivStatuses) {
        if (status.children == null) continue;

        for (var element in status.children!) {
          if (element.value == hivStatus) {
            taglineParts.add(element.label);
            break;
          }
        }
      }
    }

    if (genders.isNotEmpty && !isOrganisation) {
      for (final String gender in genders) {
        if (!genderControllerState.options.any((element) => element.value == gender)) {
          continue;
        }

        taglineParts.add(genderControllerState.options.firstWhere((element) => element.value == gender).label);
      }
    }

    if (taglineParts.isEmpty) {
      return localizations.shared_profile_tagline;
    }

    return taglineParts.join(', ');
  }

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

  String get formattedLocation {
    final AppRouter appRouter = providerContainer.read(appRouterProvider);
    final BuildContext context = appRouter.navigatorKey.currentContext!;
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    if (place?.description.isEmpty ?? true) {
      return localizations.shared_profile_unknown_location;
    }

    return place!.description;
  }

  bool get hasMarketingFeature {
    return featureFlags.contains(kFeatureFlagMarketing);
  }

  bool get isIncognito {
    return visibilityFlags.contains(kFeatureFlagIncognito);
  }
}

extension ProfileStatisticsExtensions on ProfileStatistics {
  /// a nice accessor for the data which is in a nasty little map (gets the data from the map and defaults to zero)
  int get posts => counts[ProfileStatistics.kPostKey] ?? 0;

  /// a nice accessor for the data which is in a nasty little map (gets the data from the map and defaults to zero)
  int get shares => counts[ProfileStatistics.kShareKey] ?? 0;

  /// a nice accessor for the data which is in a nasty little map (gets the data from the map and defaults to zero)
  int get followers => counts[ProfileStatistics.kFollowersKey] ?? 0;

  /// a nice accessor for the data which is in a nasty little map (gets the data from the map and defaults to zero)
  int get following => counts[ProfileStatistics.kFollowingKey] ?? 0;

  /// a nice accessor for the data which is in a nasty little map (gets the data from the map and defaults to -1 which is the error (never permitted) case)
  int get promotionsPermitted => counts[ProfileStatistics.kPromotionsPermittedKey] ?? ProfileStatistics.kPromotionsNotPermitted;
}
