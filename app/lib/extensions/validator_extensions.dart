import 'package:fluent_validation/fluent_validation.dart';

extension PositiveValidatorExtensions on AbstractRuleBuilder {
  //* Checks if the object is at least 6 characters long, contains at least one number and one special character
  AbstractRuleBuilder meetsPasswordComplexity({String? message}) {
    return must((dynamic dyn) => dyn is String && dyn.length >= 6 && dyn.contains(RegExp(r'[0-9]')) && dyn.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')), message ?? "Password must be at least 6 characters long, contain at least one number and one special character", code: "password-complexity");
  }
}
