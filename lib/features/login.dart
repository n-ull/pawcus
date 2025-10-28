import 'package:flutter/material.dart';

import 'package:go_router_plus/go_router_plus.dart';

import 'package:pawcus/core/components/password_field.dart';
import 'package:pawcus/core/router/routes.dart';
import 'package:pawcus/core/validators.dart';
import 'package:pawcus/services/auth_service.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}


class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _authService = FirebaseAuthService();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pawcus | Auth',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              children: buildSignInBody(context),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  List<Widget> buildSignInBody(BuildContext context) {
    return [
      const Text("Sign in"),
      buildEmailField(),
      PasswordField(
        controller: passwordController,
        validator: validateIsNotEmpty,
        placeholder: 'Enter your password',
      ),
      ElevatedButton(
        onPressed: _loading ? null : () => signIn(context),
        child: _loading ?
          const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : const Text("Sign in"),
      ),
    ];
  }

  Widget buildEmailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'you@example.com',
      ),
      validator: validateEmailFormat,
    );
  }

  Future<void> signIn(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    String message = 'An unexpected error occurred';
    AppUser? user;
    try {
      user = await _authService.signIn(emailController.text, passwordController.text);
      message = 'Logged in successfully as ${user.email}';
    } on AuthException catch(e) {
      message = 'Login failed: ${e.message}';
    } finally {
      if (mounted) setState(() => _loading = false);
    }

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    if (user != null) context.go(Routes.home.path);
  }
}
