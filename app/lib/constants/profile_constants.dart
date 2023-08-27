const String kVisibilityFlagName = 'name';
const String kVisibilityFlagBirthday = 'birthday';
const String kVisibilityFlagInterests = 'interests';
const String kVisibilityFlagGenders = 'genders';
const String kVisibilityFlagLocation = 'location';
const String kVisibilityFlagHivStatus = 'hiv_status';

const String kFeatureFlagMarketing = 'marketing';
const String kFeatureFlagIncognito = 'incognito';
const String kFeatureFlagOrganisationControls = 'organisationControls';

const Map<String, bool> kDefaultVisibilityFlags = {
  kVisibilityFlagName: true,
  kVisibilityFlagBirthday: true,
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
