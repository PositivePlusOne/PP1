// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/gender_controller.dart';
import 'package:app/providers/profiles/hiv_status_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_notifications_button.dart';
import 'package:app/widgets/state/positive_notifications_state.dart';
import '../constants/profile_constants.dart';
import '../dtos/database/profile/profile.dart';
import '../helpers/profile_helpers.dart';
import '../providers/profiles/profile_controller.dart';
import '../providers/system/design_controller.dart';
import '../widgets/atoms/buttons/positive_button.dart';

extension UserProfileExtensions on Profile {
  Media? get profileImage {
    return media.firstWhereOrNull((element) => element.bucketPath.contains('gallery/profile.jpeg'));
  }

  Media? get referenceImage {
    return media.firstWhereOrNull((element) => element.bucketPath.contains('private/reference.jpeg'));
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
    final DesignColorsModel colors = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);

    // Add notification information
    int unreadCount = 0;
    bool showNotificationBadge = false;
    if (profileController.currentProfileId != null) {
      final String expectedCacheKey = 'notifications:${profileController.currentProfileId}';
      final PositiveNotificationsState? notificationsState = cacheController.getFromCache(expectedCacheKey);
      if (notificationsState != null) {
        unreadCount = notificationsState.unreadCount;
        showNotificationBadge = unreadCount > 0;
      }
    }

    if (profileController.hasSetupProfile) {
      children.addAll([
        PositiveNotificationsButton(color: color, isDisabled: disableNotifications),
        PositiveButton.appBarIcon(
          colors: colors,
          primaryColor: color,
          icon: UniconsLine.user,
          onTapped: onProfileAccountActionSelected,
          isDisabled: disableAccount,
          includeBadge: showNotificationBadge,
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

  int get age {
    if (birthday.isEmpty) {
      return 0;
    }

    return DateTime.now().difference(DateTime.parse(birthday)).inDays ~/ 365;
  }

  // Checks the following properties, and comma seperates them if they are not empty and the visibility flag is set to true
  String getTagline(AppLocalizations localizations) {
    final List<String> taglineParts = [];
    final HivStatusControllerState hivControllerState = providerContainer.read(hivStatusControllerProvider);
    final GenderControllerState genderControllerState = providerContainer.read(genderControllerProvider);

    if (birthday.isNotEmpty) {
      taglineParts.add('$age');
    }

    if (place != null && place!.description.isNotEmpty) {
      taglineParts.add(place!.description);
    }

    if (hivStatus.isNotEmpty) {
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

    if (genders.isNotEmpty) {
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
