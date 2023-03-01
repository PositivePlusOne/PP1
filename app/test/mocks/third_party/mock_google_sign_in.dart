// Package imports:
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {
  MockGoogleSignIn() {
    registerFallbackValue(this);
  }

  void withMockNoUser() {
    when(() => currentUser).thenReturn(null);
  }

  void withMockUser(GoogleSignInAccount user) {
    when(() => currentUser).thenReturn(user);
  }

  void withMockSignInAccount(GoogleSignInAccount? account) {
    when(() => signIn()).thenAnswer((_) async => account);
  }
}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {
  MockGoogleSignInAccount() {
    registerFallbackValue(this);
  }

  void withMockId(String id) {
    when(() => id).thenReturn(id);
  }

  void withMockDisplayName(String mockDisplayName) {
    when(() => displayName).thenReturn(mockDisplayName);
  }

  void withMockPhotoUrl(String mockPhotoUrl) {
    when(() => photoUrl).thenReturn(mockPhotoUrl);
  }

  void withMockEmail(String mockEmail) {
    when(() => email).thenReturn(mockEmail);
  }

  void withMockAuthentication(GoogleSignInAuthentication? mockAuthentication) {
    when(() => authentication).thenAnswer((_) => Future.value(mockAuthentication));
  }
}

class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {
  MockGoogleSignInAuthentication() {
    registerFallbackValue(this);
  }

  void withMockIdToken(String mockToken) {
    when(() => idToken).thenReturn(mockToken);
  }

  void withMockAccessToken(String mockAccessToken) {
    when(() => accessToken).thenReturn(mockAccessToken);
  }
}
