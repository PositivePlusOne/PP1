import 'package:firebase_auth/firebase_auth.dart';

class PhoneVerificationCompleteEvent {
  PhoneVerificationCompleteEvent(this.user);
  final User? user;
}
