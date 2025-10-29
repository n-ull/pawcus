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


FormFieldValidator<String> validateLength(int min, {int? max}) {
  return (String? value) {
    if (value == null && min > 0) {
      return "This field can't be empty";
    }

    value = value!;

    if (value.length < min) {
      return 'Value must be at least $min characters long';
    }

    if (max != null && value.length > max) {
      return 'Value must be at most $max characters long';
    }

    return null;
  };
}


FormFieldValidator<String> validateIsNotEmpty = validateLength(1);


String? validateEmailFormat(String? value) {
  final error = validateIsNotEmpty(value);
  if (error != null) return error;

  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value!)) {
    return 'Please enter a valid email';
  }
  return null;
}


FormFieldValidator<String> validateMatches(TextEditingController expected) {
  return (String? value) {
    if (value == expected.text) return null;
    return 'Values do not match';
  };
}
