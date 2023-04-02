// Package imports:
import 'package:fluent_validation/fluent_validation.dart';

extension PositiveValidatorExtensions on AbstractRuleBuilder {
  //* Checks if the object is at least 6 characters long, contains at least one number and one special character
  AbstractRuleBuilder meetsPasswordComplexity({String? message}) {
    return must((dynamic dyn) => dyn is String && dyn.length >= 6 && dyn.contains(RegExp(r'[0-9]')) && dyn.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')), message ?? "Password must be at least 6 characters long, contain at least one number and one special character", code: "password-complexity");
  }

  //* Checks if the object is a valid ISO8601 date
  AbstractRuleBuilder isValidISO8601Date({String? message}) {
    return must((dynamic dyn) => dyn is String && DateTime.tryParse(dyn) != null, message ?? "Must be a valid ISO8601 date", code: "iso8601-date");
  }

  AbstractRuleBuilder isMinimumInterestsLength({String? message}) {
    return must((dynamic dyn) => dyn is List && dyn.length >= 3, message ?? "Must have at least 3 interests", code: "min-interests-length");
  }

  AbstractRuleBuilder isEqualTo(String expectedString, {String? message}) {
    return must((dynamic dyn) => dyn is String && dyn == expectedString, message ?? "Must match $expectedString", code: "matches");
  }

  AbstractRuleBuilder isNotEqualTo(String expectedString, {String? message}) {
    return must((dynamic dyn) => dyn is String && dyn != expectedString, message ?? "Must not match $expectedString", code: "not-equal-to");
  }
}
