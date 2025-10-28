import 'package:flutter/material.dart';


FormFieldValidator<T> composeValidators<T>(List<FormFieldValidator<T>> validators) {
  return (value) {
    for (FormFieldValidator<T> validator in validators) {
      String? error = validator(value);
      if (error != null) return error;
    }
    return null;
  };
}


String? validateIsNotEmpty(String? value) {
  if (value == null || value.isEmpty) {
    return "This field can't be empty";
  }

  return null;
}


String? validateEmailFormat(String? value) {
  final error = validateIsNotEmpty(value);
  if (error != null) return error;

  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value!)) {
    return 'Please enter a valid email';
  }
  return null;
}
