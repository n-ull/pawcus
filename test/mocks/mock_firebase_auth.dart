import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';


class TestFirebaseAuth extends MockFirebaseAuth {
  final Set<String> _validUsers = {};
  final Set<String> _existingEmails = {};

  TestFirebaseAuth({super.signedIn, super.mockUser});

  void addValidUser(String email, String password) {
    _validUsers.add('$email:$password');
    _existingEmails.add(email);
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userKey = '$email:$password';
    if (!_validUsers.contains(userKey)) {
      throw FirebaseAuthException(
        code: 'invalid-credential',
        message:
            'The supplied auth credential is incorrect, malformed or has expired.',
      );
    }
    return super.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (_existingEmails.contains(email)) {
      throw FirebaseAuthException(code: 'email-already-in-use', message: 'email-already-in-use');
    }
    addValidUser(email, password);
    return super.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
