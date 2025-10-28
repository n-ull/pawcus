import 'package:flutter/material.dart';


class PasswordField extends StatefulWidget {
  final String? placeholder;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const PasswordField({super.key, this.placeholder, this.validator, this.controller});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}


class _PasswordFieldState extends State<PasswordField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: TextFormField(
          controller: widget.controller,
          obscureText: !_visible,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.placeholder ?? 'Password',
          ),
        )),
        IconButton(
          onPressed: () => setState(() => _visible = !_visible),
          icon: Icon(_visible ? Icons.visibility_off : Icons.visibility),
          tooltip: _visible ? 'Hide password' : 'Show password',
        ),
      ],
    );
  }
}
