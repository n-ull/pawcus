import 'package:firebase_auth/firebase_auth.dart';


class User {
  final String email;

  const User({required this.email});
}


class AuthService {
  static Future<String> login(String email, String password) async {
    print(email);
    print(password);
    try {
      final _ = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Logged in succesfully.';
    } on FirebaseAuthException catch(e) {
      print(e);
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-credential') {
        return 'Wrong password provided for that user.';
      }
      return 'Unknown error';
    }
  }
}
