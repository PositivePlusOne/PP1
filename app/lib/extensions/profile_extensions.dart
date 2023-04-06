// Project imports:
import '../constants/profile_constants.dart';
import '../dtos/database/user/user_profile.dart';

extension UserProfileExtensions on UserProfile {
  bool get hasReferenceImages => referenceImages != null && referenceImages is Iterable && (referenceImages as Iterable).isNotEmpty;

  Map<String, bool> buildFormVisibilityFlags() {
    // If the user has not set the field then the visibility flag should be set to the default value
    // If they have set the field then the visibility flag should be set using the set from the database
    final Map<String, bool> visibilityFlags = {
      kVisibilityFlagBirthday: birthday.isNotEmpty ? this.visibilityFlags.contains(kVisibilityFlagBirthday) : (kDefaultVisibilityFlags[kVisibilityFlagBirthday] ?? false),
      kVisibilityFlagIdentity: this.visibilityFlags.contains(kVisibilityFlagIdentity),
      kVisibilityFlagInterests: interests.isNotEmpty ? this.visibilityFlags.contains(kVisibilityFlagInterests) : (kDefaultVisibilityFlags[kVisibilityFlagInterests] ?? false),
      kVisibilityFlagLocation: this.visibilityFlags.contains(kVisibilityFlagLocation),
      kVisibilityFlagName: this.visibilityFlags.contains(kVisibilityFlagName),
      kVisibilityFlagGenders: genders.isNotEmpty ? this.visibilityFlags.contains(kVisibilityFlagGenders) : (kDefaultVisibilityFlags[kVisibilityFlagGenders] ?? false),
      kVisibilityFlagHivStatus: hivStatus.isNotEmpty ? this.visibilityFlags.contains(kVisibilityFlagHivStatus) : (kDefaultVisibilityFlags[kVisibilityFlagHivStatus] ?? false),
    };
    return visibilityFlags;
  }
}
