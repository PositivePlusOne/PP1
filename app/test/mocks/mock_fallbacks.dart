// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

void registerMockFallbacks() {
  registerFallbackValue(AuthCredentialFake());
  registerFallbackValue(OAuthProviderFake());
}

class AuthCredentialFake extends Fake implements AuthCredential {}

class OAuthProviderFake extends Fake implements OAuthProvider {}
