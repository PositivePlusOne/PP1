import 'package:app/providers/user/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

extension ExceptionExtensions on Object? {
  Future<void> handleError(NotifierProviderRef ref) async {
    // requires-recent-login

    if (this is FirebaseAuthException) {
      await handleFirebaseAuthException(this as FirebaseAuthException, ref);
    }
  }

  Future<void> handleFirebaseAuthException(FirebaseAuthException error, NotifierProviderRef ref) async {
    switch (error.code) {
      case 'requires-recent-login':
        await ref.read(userControllerProvider.notifier).timeoutSession();
        break;
      default:
        break;
    }
  }
}
