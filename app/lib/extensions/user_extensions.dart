// Package imports:
import 'package:firebase_auth/firebase_auth.dart';

extension UserExtensions on User {
  //* Check all the provider data for any strings named "name" or "fullName"
  //* and return the first one that is not null or empty
  String? get providerName {
    String? providerName;
    for (final UserInfo userInfo in providerData) {
      final String? name = userInfo.displayName;
      if (name != null && name.isNotEmpty) {
        providerName = name;
        break;
      }
    }

    return providerName;
  }
}
