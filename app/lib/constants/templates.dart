// Project imports:
import 'package:app/dtos/database/profile/profile.dart';

String userReportTemplate(Profile reportee, Profile reporter, String comment) {
  return """
Reporter ID: ${reporter.id}
Reporter Display Name: ${reporter.displayName}

Reported User ID: ${reportee.id}
Reported User Display Name: ${reportee.displayName}

Comment: $comment
""".trim();
}
