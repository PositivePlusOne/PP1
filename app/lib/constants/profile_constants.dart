const String kVisibilityFlagName = 'name';
const String kVisibilityFlagBirthday = 'birthday';
const String kVisibilityFlagInterests = 'interests';
const String kVisibilityFlagGenders = 'genders';
const String kVisibilityFlagLocation = 'location';
const String kVisibilityFlagHivStatus = 'hiv_status';
const String kVisibilityFlagCompanySectors = 'company_sectors';

const String kFeatureFlagMarketing = 'marketing';
const String kFeatureFlagIncognito = 'incognito';
const String kFeatureFlagOrganisation = 'organisation';
const String kFeatureFlagPendingDeletion = 'pending_deletion';
const String kFeatureFlagVerified = 'verified';

const String kAccountFlagNameOffensive = 'name_offensive';
const String kAccountFlagDisplayNameOffensive = 'display_name_offensive';

const Map<String, bool> kDefaultVisibilityFlags = {
  kVisibilityFlagName: false,
  kVisibilityFlagBirthday: false,
  kVisibilityFlagInterests: false,
  kVisibilityFlagGenders: false,
  kVisibilityFlagLocation: false,
  kVisibilityFlagHivStatus: false,
  kVisibilityFlagCompanySectors: false,
};

const Map<String, bool> kDefaultFeatureFlags = {
  kFeatureFlagMarketing: false,
};

const int kAgeRequirement13 = 13;
const int kBiographyMaxLength = 320;
