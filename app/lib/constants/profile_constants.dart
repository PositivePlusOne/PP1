const String kVisibilityFlagName = 'name';
const String kVisibilityFlagBirthday = 'birthday';
const String kVisibilityFlagIdentity = 'identity';
const String kVisibilityFlagMedical = 'medical';
const String kVisibilityFlagInterests = 'interests';
const String kVisibilityFlagGenders = 'genders';
const String kVisibilityFlagLocation = 'location';

const Map<String, bool> kDefaultVisibilityFlags = {
  kVisibilityFlagName: true,
  kVisibilityFlagBirthday: true,
  kVisibilityFlagIdentity: true,
  kVisibilityFlagMedical: true,
  kVisibilityFlagInterests: true,
  kVisibilityFlagGenders: true,
  kVisibilityFlagLocation: true,
};

const Duration kMinimumAgeRequirement = Duration(days: 365 * 13);
