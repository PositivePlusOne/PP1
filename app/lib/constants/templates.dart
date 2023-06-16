// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:app/dtos/database/profile/profile.dart';

String userReportTemplate(Profile reportee, Profile reporter, String comment) {
  final reportData = {
    'reporterId': reporter.id,
    'reporterDisplayName': reporter.displayName,
    'reportedUserId': reportee.id,
    'reportedUserDisplayName': reportee.displayName,
    'comment': comment,
  };

  final reportJson = json.encode(reportData);
  return reportJson;
}
