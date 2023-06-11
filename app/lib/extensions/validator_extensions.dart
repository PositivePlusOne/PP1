// Package imports:
import 'package:fluent_validation/fluent_validation.dart';
import 'package:profanity_filter/profanity_filter.dart';

final ProfanityFilter _profanityFilter = ProfanityFilter();

extension PositiveValidatorExtensions on AbstractRuleBuilder {
  //* Checks if the object is at least 6 characters long, contains at least one number and one special character
  AbstractRuleBuilder meetsPasswordComplexity({String? message}) {
    return must((dynamic dyn) => dyn is String && dyn.length >= 6 && dyn.contains(RegExp(r'[0-9]')) && dyn.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')), message ?? "Password must be at least 6 characters long, contain at least one number and one special character", code: "passwordComplexity");
  }

  //* Checks if the object is a valid ISO8601 date
  AbstractRuleBuilder isValidISO8601Date({String? message}) {
    return must((dynamic dyn) => dyn is String && DateTime.tryParse(dyn) != null, message ?? "Must be a valid ISO8601 date", code: "iso8601Date");
  }

  //* Checks if the object is profane
  AbstractRuleBuilder isProfane({String? message}) {
    return must((dynamic dyn) => dyn is String && !_profanityFilter.hasProfanity(dyn), message ?? "Must not contain profanity", code: "profanity");
  }

  //* Checks if the object is alphanumeric
  AbstractRuleBuilder isAlphaNumeric({String? message}) {
    return must((dynamic dyn) => dyn is String && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(dyn), message ?? "Must be alphanumeric", code: "alphaNumeric");
  }

  AbstractRuleBuilder containsNoEmoji({String? message}) {
    return must((dynamic dyn) => dyn is String && !RegExp(r'[^\w\s]', multiLine: true).hasMatch(dyn), message ?? "Must not contain emoji", code: "emoji");
  }

  //* Checks if the object is valid display name length
  AbstractRuleBuilder isDisplayNameLength({String? message}) {
    return must((dynamic dyn) => dyn is String && dyn.length >= 3 && dyn.length <= 15, message ?? "Must be between 3 and 15 characters long", code: "displayNameLength");
  }

  AbstractRuleBuilder isMinimumInterestsLength({String? message}) {
    return must((dynamic dyn) => dyn is Set && dyn.isNotEmpty, message ?? "Must select at least 1 interest", code: "minInterestsLength");
  }

  AbstractRuleBuilder isEqualTo(String expectedString, {String? message}) {
    return must((dynamic dyn) => dyn is String && dyn == expectedString, message ?? "Must match $expectedString", code: "matches");
  }

  AbstractRuleBuilder isNotEqualTo(String expectedString, {String? message}) {
    return must((dynamic dyn) => dyn is String && dyn != expectedString, message ?? "Must not match $expectedString", code: "notEqualTo");
  }
}
