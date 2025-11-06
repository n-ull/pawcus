import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawcus/core/components/password_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pawcus/core/services/service_locator.dart';
import 'package:pawcus/features/login.dart';
import 'package:pawcus/features/pet/pet_screen.dart';
import 'package:pawcus/main.dart';
import 'package:pawcus/services/auth_service.dart';

import '../mocks/mock_firebase_auth.dart';


void main() {
  const testUserEmail = 'test@example.com';
  const testUserPassword = 'password';
  late final AuthService auth;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    auth = FirebaseAuthService(auth: TestFirebaseAuth());
    await auth.signUp(testUserEmail, testUserPassword);
    await auth.signOut();
    await setupServiceLocator(authService: auth);
  });

  Future<void> loadApp(tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
  }

  testWidgets('Redirects unauthenticated users to sign in', (tester) async {
    await loadApp(tester);
    expect(find.byType(PetScreen), findsNothing);
    expect(find.byType(AuthScreen), findsOneWidget);
    expect(find.text('Pawcus | Sign in'), findsOneWidget);
  });

  testWidgets('Loads home for logged in users', (tester) async {
    await auth.signIn(testUserEmail, testUserPassword);
    await loadApp(tester);

    expect(find.byType(PetScreen), findsOneWidget);
    await auth.signOut();
  });

  testWidgets('AuthScreen changes between Sign in and Sign up', (tester) async {
    await loadApp(tester);
    expect(find.text('Confirm your password'), findsNothing);
    await tester.tap(find.text(' Sign up'));
    await tester.pumpAndSettle();
    expect(find.text('Confirm your password'), findsOneWidget);

    await tester.tap(find.text(' Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Confirm your password'), findsNothing);
    expect(find.text("Don't have an account yet?"), findsOneWidget);
  });

  group('Sign in', () {
    testWidgets('Sign in renders correctly', (tester) async {
      await loadApp(tester);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
      expect(find.text("Don't have an account yet?"), findsOneWidget);
      expect(find.text(" Sign up"), findsOneWidget);
    });

    testWidgets('Shows error message on failed sign in', (tester) async {
      await loadApp(tester);
      await tester.enterText(find.widgetWithText(TextFormField, 'you@example.com'), 'invalid@example.com');
      await tester.enterText(find.widgetWithText(PasswordField, 'Enter your password'), 'wrongpassword');
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Sign in failed: Invalid credentials'), findsOneWidget);
    });

    testWidgets('Shows error message on invalid email', (tester) async {
      await loadApp(tester);
      await tester.enterText(find.widgetWithText(TextFormField, 'you@example.com'), 'invalid');
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Please enter a valid email', findRichText: true), findsOneWidget);
    });

    testWidgets('Shows error message on empty fields', (tester) async {
      await loadApp(tester);
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      expect(find.textContaining("This field can't be empty", findRichText: true), findsExactly(2));
    });

    testWidgets('Correct credentials sign in succesfully', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 2000)); // ✅ prevent overflow
      await loadApp(tester);

      await tester.enterText(find.widgetWithText(TextFormField, 'you@example.com'), testUserEmail);
      await tester.enterText(find.widgetWithText(PasswordField, 'Enter your password'), testUserPassword);
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(find.byType(PetScreen), findsOneWidget);
      await auth.signOut();
    });
  });

  group('Sign up', () {

    Future<void> loadSignUp(tester) async {
      await loadApp(tester);
      await tester.tap(find.text(' Sign up'));
      await tester.pumpAndSettle();
    }

    testWidgets('Sign up renders correctly', (tester) async {
      await loadSignUp(tester);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
      expect(find.text('Confirm your password'), findsOneWidget);
      expect(find.text('Already have an account?'), findsOneWidget);
      expect(find.text(' Sign in'), findsOneWidget);
    });

    testWidgets('Shows error message on failed sign up', (tester) async {
      await loadSignUp(tester);
      await tester.enterText(find.widgetWithText(TextFormField, 'you@example.com'), testUserEmail);
      await tester.enterText(find.widgetWithText(PasswordField, 'Enter your password'), 'anotherPassword');
      await tester.enterText(find.widgetWithText(PasswordField, 'Confirm your password'), 'anotherPassword');
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();
      expect(find.textContaining('An account already exists for that email'), findsOneWidget);
    });

    testWidgets('Shows error message on invalid email', (tester) async {
      await loadSignUp(tester);
      await tester.enterText(find.widgetWithText(TextFormField, 'you@example.com'), 'invalid');
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Please enter a valid email', findRichText: true), findsOneWidget);
    });

    testWidgets('Shows error message on empty fields', (tester) async {
      await loadSignUp(tester);
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();
      expect(find.textContaining("This field can't be empty", findRichText: true), findsExactly(3));
    });

    testWidgets("Shows error message when passwords don't match", (tester) async {
      await loadSignUp(tester);
      await tester.enterText(find.widgetWithText(TextFormField, 'you@example.com'), 'test@example.com');
      await tester.enterText(find.widgetWithText(PasswordField, 'Enter your password'), 'password1');
      await tester.enterText(find.widgetWithText(PasswordField, 'Confirm your password'), 'password2');
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Values do not match', findRichText: true), findsOneWidget);
    });

    testWidgets('Correct credentials sign up succesfully', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 2000)); // ✅ prevent overflow
      await loadSignUp(tester);

      await tester.enterText(find.widgetWithText(TextFormField, 'you@example.com'), 'other-email@example.com');
      await tester.enterText(find.widgetWithText(PasswordField, 'Enter your password'), 'anotherPassword');
      await tester.enterText(find.widgetWithText(PasswordField, 'Confirm your password'), 'anotherPassword');
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();

      expect(find.byType(PetScreen), findsOneWidget);
      await auth.signOut();
    });
  });
}
