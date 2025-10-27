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
      if (credential.user?.email == null) {
        // We shouldn't reach this point. Users should always have an email in our app
        throw AuthException('User email is not available');
      }
      return AppUser(email: credential.user!.email!);
    } on FirebaseAuthException catch(e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        throw AuthException('Invalid credentials');
      }
      if (e.code == 'invalid-email') {
        throw AuthException('E-mail is wrongly formatted');
      }
    } catch(e) {
      // Handle unexpected errors
      throw AuthException('An unexpected error occured during sign in');
    }
    return null;
  }

  @override
  Future<AppUser?> signUp(String email, String password) async {
    throw UnimplementedError('Sign up is not yet implemented');
  }

  @override
  Future<void> signOut() async {
    throw UnimplementedError('Sign out is not yet implemented');
  }

  @override
  AppUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    if (user.email == null) {
        // We shouldn't reach this point. Users should always have an email in our app
      throw AuthException('User email is not available');
    }
    return AppUser(email: user.email!);
  }
}
