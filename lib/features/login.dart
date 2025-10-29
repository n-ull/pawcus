import 'package:flutter/material.dart';

import 'package:go_router_plus/go_router_plus.dart';

import 'package:pawcus/core/components/password_field.dart';
import 'package:pawcus/core/router/routes.dart';
import 'package:pawcus/core/validators.dart';
import 'package:pawcus/services/auth_service.dart';


enum AuthAction {
  signIn,
  signUp,
}


const minPasswordLength = 8;
const maxPasswordLength = 128;


class AuthScreen extends StatefulWidget {
  final AuthAction action;

  const AuthScreen({super.key, this.action = AuthAction.signIn});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}


class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _authService = FirebaseAuthService();
  bool _loading = false;
  late AuthAction currentAction;

  @override
  void initState() {
    super.initState();
    currentAction = widget.action;
  }

  @override
  Widget build(BuildContext context) {
    String title;
    List<Widget> Function(BuildContext) bodyBuilder;
    if (currentAction == AuthAction.signIn) {
      title = 'Sign in';
      bodyBuilder = buildSignInBody;
    } else {
      title = 'Sign up';
      bodyBuilder = buildSignUpBody;
    }

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Pawcus | $title',
          style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              children: bodyBuilder(context),
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
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't have an account yet?"),
          InkWell(
            onTap: () => setState(() => currentAction = AuthAction.signUp),
            child: Text(
              " Sign up",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
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

  List<Widget> buildSignUpBody(BuildContext context) {
    FormFieldValidator<String> passwordValidator = validateLength(minPasswordLength, max: maxPasswordLength);
    return [
      const Text('Sign up'),
      buildEmailField(),
      PasswordField(
        controller: passwordController,
        validator: passwordValidator,
        placeholder: 'Enter your password',
      ),
      PasswordField(
        validator: composeValidators([passwordValidator, validateMatches(passwordController)]),
        placeholder: 'Confirm your password',
      ),
      ElevatedButton(
        onPressed: _loading ? null : () => signUp(context),
        child: _loading ?
          const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : const Text("Sign up"),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already have an account?"),
          InkWell(
            onTap: () => setState(() => currentAction = AuthAction.signIn),
            child: Text(
              " Sign in",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    ];
  }

  Future<void> signUp(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    print("Sign up mock");
  }
}
