import 'package:test/test.dart';

import 'package:pawcus/services/auth_service.dart';

import '../mocks/mock_firebase_auth.dart';


void main() {
  group('FirebaseAuthService', () {
    runAuthServiceContractTests(() {
      final mockAuth = TestFirebaseAuth();
      return FirebaseAuthService(auth: mockAuth);
    });
  });
}

void runAuthServiceContractTests(AuthService Function() createAuthService) {
  group('AuthService contract', () {
    late AuthService auth;
    const testUserEmail = 'test@example.com';
    const testUserPassword = 'password';

    setUp(() => auth = createAuthService());

    Future<void> createTestUser() async {
      await auth.signUp(testUserEmail, testUserPassword);
      await auth.signOut();
    }

    test('Starts unauthenticated', () {
      expect(auth.isAuthenticated(), isFalse);
      expect(auth.currentUser, isNull);
    });

    test('signUp creates and authenticates user', () async {
      await auth.signUp(testUserEmail, testUserPassword);
      expect(auth.isAuthenticated(), isTrue);
      expect(auth.currentUser, isA<AppUser>());
      expect(auth.currentUser?.email, testUserEmail);
    });

    test('signIn authenticates user', () async {
      await createTestUser();
      await auth.signIn(testUserEmail, testUserPassword);
      expect(auth.isAuthenticated(), isTrue);
      expect(auth.currentUser, isA<AppUser>());
      expect(auth.currentUser?.email, testUserEmail);
    });

    test('signIn throws AuthException for invalid credentials', () async {
      await expectLater(
        auth.signIn('invalid@example.com', 'wrongpassword'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            equals('Invalid credentials'),
          ),
        ),
      );
    });

    test('signOut unauthenticates user', () async {
      await createTestUser();
      await auth.signIn(testUserEmail, testUserPassword);
      expect(auth.isAuthenticated(), isTrue);
      expect(auth.currentUser, isA<AppUser>());
      await auth.signOut();
      expect(auth.isAuthenticated(), isFalse);
      expect(auth.currentUser, isNull);
    });
  });
}
