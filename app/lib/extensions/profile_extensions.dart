// Project imports:
import '../constants/profile_constants.dart';
import '../dtos/database/user/user_profile.dart';

extension UserProfileExtensions on UserProfile {
  bool get hasReferenceImages => referenceImages != null && referenceImages is Iterable && (referenceImages as Iterable).isNotEmpty;

  Map<String, bool> buildFormVisibilityFlags() {
    final Map<String, bool> visibilityFlags = {
      kVisibilityFlagBirthday: this.visibilityFlags.contains(kVisibilityFlagBirthday),
      kVisibilityFlagIdentity: this.visibilityFlags.contains(kVisibilityFlagIdentity),
      kVisibilityFlagInterests: this.visibilityFlags.contains(kVisibilityFlagInterests),
      kVisibilityFlagLocation: this.visibilityFlags.contains(kVisibilityFlagLocation),
      kVisibilityFlagName: this.visibilityFlags.contains(kVisibilityFlagName),
    };

    return visibilityFlags;
  }
}
