// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

void registerMockFallbacks() {
  registerFallbackValue(AuthCredentialFake());
  registerFallbackValue(OAuthProviderFake());
  registerFallbackValue(FakePageRouteInfo());
}

class AuthCredentialFake extends Fake implements AuthCredential {}

class OAuthProviderFake extends Fake implements OAuthProvider {}

class FakePageRouteInfo<T> extends Fake implements PageRouteInfo<T> {}
