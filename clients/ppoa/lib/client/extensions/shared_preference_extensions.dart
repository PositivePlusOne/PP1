import 'package:shared_preferences/shared_preferences.dart';

import '../constants/ppo_preference_keys.dart';

extension SharedPreferencesExtensions on SharedPreferences {
  Future<bool> hasViewedOurPledge() async {
    final bool? val = getBool(kSwitchAcceptedOurPledge);
    return val != null && val;
  }

  Future<bool> hasViewedTheirPledge() async {
    final bool? val = getBool(kSwitchAcceptedYourPledge);
    return val != null && val;
  }

  Future<bool> hasViewedPledges() async {
    return await hasViewedOurPledge() && await hasViewedTheirPledge();
  }
}
