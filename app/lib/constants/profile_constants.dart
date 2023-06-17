const String kVisibilityFlagName = 'name';
const String kVisibilityFlagBirthday = 'birthday';
const String kVisibilityFlagIdentity = 'identity';
const String kVisibilityFlagMedical = 'medical';
const String kVisibilityFlagInterests = 'interests';
const String kVisibilityFlagGenders = 'genders';
const String kVisibilityFlagLocation = 'location';
const String kVisibilityFlagHivStatus = 'hiv_status';

const String kFeatureFlagMarketing = 'marketing';
const String kFeatureFlagIncognito = 'incognito';

const Map<String, bool> kDefaultVisibilityFlags = {
  kVisibilityFlagName: true,
  kVisibilityFlagBirthday: true,
  kVisibilityFlagIdentity: true,
  kVisibilityFlagMedical: true,
  kVisibilityFlagInterests: true,
  kVisibilityFlagGenders: true,
  kVisibilityFlagLocation: true,
  kVisibilityFlagHivStatus: true,
};

const Map<String, bool> kDefaultFeatureFlags = {
  kFeatureFlagMarketing: false,
};

const int kAgeRequirement13 = 13;
const int kBiographyMaxLength = 200;
