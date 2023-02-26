// Package imports:
import 'package:firebase_auth/firebase_auth.dart';

class PhoneVerificationFailedEvent {
  const PhoneVerificationFailedEvent(this.firebaseAuthException);
  final FirebaseAuthException firebaseAuthException;
}
