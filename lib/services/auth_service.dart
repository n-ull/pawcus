import 'package:firebase_auth/firebase_auth.dart';


class User {
  final String email;

  const User({required this.email});
}


class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => 'Auth error: $message';
}


abstract class AuthService {
  Future<User?> signIn(String email, String password);
  Future<User?> signUp(String email, String password);
  Future<void> signOut();
  User? get currentUser;
}


class FirebaseAuthService implements AuthService {
  @override
  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return User(email: credential.user!.email!);
    } on FirebaseAuthException catch(e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw AuthException('Invalid credentials');
      }
      if (e.code == 'invalid-email') {
        throw AuthException('E-mail is wrongly formatted');
      }
      return null;
    }
  }

  @override
  Future<User?> signUp(String email, String password) async {
    return null;
  }

  @override
  Future<void> signOut() async {
    
  }

  @override
  User? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return User(email: user.email!);
  }
}
