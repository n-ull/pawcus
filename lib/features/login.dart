import 'package:flutter/material.dart';

import 'package:go_router_plus/go_router_plus.dart';

import 'package:pawcus/core/components/password_field.dart';
import 'package:pawcus/core/router/routes.dart';
import 'package:pawcus/services/auth_service.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  bool loggedIn = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pawcus | Login'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("Login"),
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                ),
              ),
              PasswordField(
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                placeholder: 'Enter your password',
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  String message;
                  User? user;
                  try {
                    user = await FirebaseAuthService().signIn(emailController.text, passwordController.text);
                    message = 'Logged in successfully as ${user!.email}';
                  } on AuthException catch(e) {
                    message = e.toString();
                  }

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );

                  if (user != null) context.go(Routes.home.path);
                },
                child: const Text("Login!"),
              )
            ]
          ),
        ),
      ),
    );
  }
}
