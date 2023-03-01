// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  MockFirebaseAuth() {
    registerFallbackValue(this);
  }

  void withMockUserCredential(UserCredential credential) {
    when(() => signInWithCredential(any())).thenAnswer((_) async => credential);
    when(() => signInWithProvider(any())).thenAnswer((_) async => credential);
    when(() => signInWithPopup(any())).thenAnswer((_) async => credential);
  }
}

class MockFirebaseUserCredential extends Mock implements UserCredential {
  MockFirebaseUserCredential() {
    registerFallbackValue(this);
  }

  // Whether or not the user is new to the app.
  void withMockUserInformation(AdditionalUserInfo info) {
    when(() => additionalUserInfo).thenReturn(info);
  }

  void withMockUser(User mockUser) {
    when(() => user).thenReturn(mockUser);
  }
}

class MockFirebaseUser extends Mock implements User {
  MockFirebaseUser() {
    registerFallbackValue(this);
    withMockDetails();
  }

  void withMockDetails() {
    when(() => displayName).thenReturn('');
    when(() => email).thenReturn('');
    when(() => phoneNumber).thenReturn('');
    when(() => photoURL).thenReturn('');
    when(() => providerData).thenReturn([]);
    when(() => uid).thenReturn('1234567890');
  }
}
