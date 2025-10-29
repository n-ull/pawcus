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
  Future<AppUser> signIn(String email, String password);
  Future<AppUser> signUp(String email, String password);
  Future<void> signOut();
  AppUser? get currentUser;
}


class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth;
  FirebaseAuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<AppUser> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _getUserFromCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        throw const AuthException('Invalid credentials');
      }
      if (e.code == 'invalid-email') {
        throw const AuthException('E-mail is wrongly formatted');
      }
      if (e.code == 'too-many-requests') {
        throw const AuthException('Too many attempts. Try again later');
      }
      if (e.code == 'user-disabled') {
        throw const AuthException('Account is disabled');
      }
      throw AuthException(e.message ?? e.code);
    } catch (e) {
      throw const AuthException('An unexpected error occurred during sign in');
    }
  }

  @override
  Future<AppUser> signUp(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _getUserFromCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw const AuthException('E-mail is wrongly formatted');
      }
      if (e.code == 'too-many-requests') {
        throw const AuthException('Too many attempts. Try again later');
      }
      if (e.code == 'weak-password') {
        throw const AuthException('The password provided is too weak');
      }
      if (e.code == 'email-already-in-use') {
        throw const AuthException('An account already exists for that email');
      }
      throw AuthException(e.message ?? e.code);
    } catch (e) {
      throw const AuthException('An unexpected error occurred during sign up');
    }
  }

  @override
  Future<void> signOut() async {
    throw UnimplementedError('Sign out is not yet implemented');
  }

  @override
  AppUser? get currentUser {
    final user = _auth.currentUser;
    if (user == null || user.email == null) return null;
    return AppUser(email: user.email!);
  }

  AppUser _getUserFromCredential(UserCredential credential) {
    final user = credential.user;
    final userEmail = user?.email;
    if (userEmail == null) {
      // We shouldn't reach this point. Users should always have an email in our app
      throw const AuthException('User email is not available');
    }
    return AppUser(email: userEmail);
  }
}
