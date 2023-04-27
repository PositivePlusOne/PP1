// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:app/main.dart';
import '../constants/profile_constants.dart';
import '../dtos/database/user/user_profile.dart';
import '../providers/content/gender_controller.dart';
import '../providers/content/hiv_status_controller.dart';

extension UserProfileExtensions on UserProfile {
  Map<String, bool> buildFormVisibilityFlags() {
    // If the user has not set the field then the visibility flag should be set to the default value
    // If they have set the field then the visibility flag should be set using the set from the database
    final Map<String, bool> visibilityFlags = {
      kVisibilityFlagBirthday: birthday.isNotEmpty ? this.visibilityFlags.contains(kVisibilityFlagBirthday) : (kDefaultVisibilityFlags[kVisibilityFlagBirthday] ?? false),
      kVisibilityFlagIdentity: this.visibilityFlags.contains(kVisibilityFlagIdentity),
      kVisibilityFlagInterests: interests.isNotEmpty ? this.visibilityFlags.contains(kVisibilityFlagInterests) : (kDefaultVisibilityFlags[kVisibilityFlagInterests] ?? false),
      kVisibilityFlagLocation: location != null || locationSkipped ? this.visibilityFlags.contains(kVisibilityFlagLocation) : (kDefaultVisibilityFlags[kVisibilityFlagLocation] ?? false),
      kVisibilityFlagName: this.visibilityFlags.contains(kVisibilityFlagName),
      kVisibilityFlagGenders: genders.isNotEmpty ? this.visibilityFlags.contains(kVisibilityFlagGenders) : (kDefaultVisibilityFlags[kVisibilityFlagGenders] ?? false),
      kVisibilityFlagHivStatus: hivStatus.isNotEmpty ? this.visibilityFlags.contains(kVisibilityFlagHivStatus) : (kDefaultVisibilityFlags[kVisibilityFlagHivStatus] ?? false),
    };

    return visibilityFlags;
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

    if (visibilityFlags.contains(kVisibilityFlagBirthday) && birthday.isNotEmpty) {
      taglineParts.add('$age');
    }

    if (visibilityFlags.contains(kVisibilityFlagHivStatus) && hivStatus.isNotEmpty && hivControllerState.hivStatuses.any((element) => element.value == hivStatus)) {
      final String hivStatusOption = hivControllerState.hivStatuses.firstWhere((element) => element.value == hivStatus).label;
      taglineParts.add(hivStatusOption);
    }

    if (visibilityFlags.contains(kVisibilityFlagGenders) && genders.isNotEmpty) {
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

  String get formattedLocationIgnoreFlags {
    //TODO Store location string alongside lat long
    return "TODO";
  }
}
