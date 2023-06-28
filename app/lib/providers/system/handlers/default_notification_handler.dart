import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/handlers/notification_handler.dart';
import 'package:app/services/third_party.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DefaultNotificationHandler extends NotificationHandler {
  @override
  bool canHandlePayload(NotificationPayload payload, bool isForeground) {
    return true;
  }

  @override
  Future<bool> canTriggerPayload(NotificationPayload payload, bool isForeground) async {
    return false;
  }

  @override
  Future<bool> canDisplayPayload(NotificationPayload payload, bool isForeground) async {
    final FirebaseAuth firebaseAuth = providerContainer.read(firebaseAuthProvider);
    if (firebaseAuth.currentUser == null) {
      return false;
    }

    return payload.dismissed == false && payload.title.isNotEmpty && payload.body.isNotEmpty;
  }
}
