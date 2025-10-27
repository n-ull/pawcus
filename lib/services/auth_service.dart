import 'package:firebase_auth/firebase_auth.dart';


class AppUser {
  final String email;

  const AppUser({required this.email});
}


class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => 'Auth error: $message';
}


abstract class AuthService {
  Future<AppUser?> signIn(String email, String password);
  Future<AppUser?> signUp(String email, String password);
  Future<void> signOut();
  AppUser? get currentUser;
}


class FirebaseAuthService implements AuthService {
  @override
  Future<AppUser?> signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AppUser(email: credential.user!.email!);
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
  Future<AppUser?> signUp(String email, String password) async {
    return null;
  }

  @override
  Future<void> signOut() async {
    
  }

  @override
  AppUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return AppUser(email: user.email!);
  }
}
