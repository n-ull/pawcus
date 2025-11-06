import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';


class TestFirebaseAuth extends MockFirebaseAuth {
  final Set<String> _validUsers = {};

  TestFirebaseAuth({super.signedIn, super.mockUser});

  void addValidUser(String email, String password) {
    _validUsers.add('$email:$password');
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
    final userKey = '$email:$password';
    _validUsers.add(userKey);
    return super.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
