// Package imports:
import 'package:fluent_validation/fluent_validation.dart';
import 'package:profanity_filter/profanity_filter.dart';

// Project imports:
import 'package:app/dtos/database/feedback/feedback_type.dart';
import 'package:app/dtos/database/feedback/feedback_wrapper.dart';
import 'package:app/dtos/database/feedback/report_type.dart';

final ProfanityFilter _profanityFilter = ProfanityFilter();

extension PositiveValidatorExtensions on AbstractRuleBuilder {
  //* Checks if the object is at least 8 characters long, contains at least one number and one special character
  AbstractRuleBuilder meetsPasswordComplexity({String? message}) {
    // (?=.*[0-9]) - has to contain a number - 0-9
    // (?=.*[a-z]) - has to contain a normal letter (lowercase)
    // (?=.*[A-Z]) - has to contain a normal letter (uppercase)
    // (?=.*[\W_]) - has to contain a special char, or an underscore (not included in \W) (space being a special character though)
    // .{8,}$ - has to be at least 8 chars long
    // .{8,16}$ - has to be between 8 and 16 chars long
    return must((dynamic dyn) => dyn is String && dyn.contains(RegExp(r'^(?=.*[0-9])(?=.*[\W_]).{8,}$')), message ?? "Password must be at least 8 characters long, contain at least one number and one special character", code: "passwordComplexity");
  }

  AbstractRuleBuilder isFormattedEmailAddress({String? message}) {
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return must((dynamic dyn) => dyn is String && emailRegex.hasMatch(dyn), message ?? (useKeyAsElementName ? "$key must be a valid email address" : "String must be a valid email address"), code: "notValidEmailAddress");
  }

  AbstractRuleBuilder isValidReportTypeOrNotAReport({String? message}) {
    return must((dynamic dyn) {
      final bool isWrapper = dyn is FeedbackWrapper;
      final bool isUserOrPostReport = isWrapper && (dyn.feedbackType == const FeedbackType.userReport() || dyn.feedbackType == const FeedbackType.postReport());
      final bool hasReportType = isWrapper && dyn.reportType != const ReportType.unknown();

      return isWrapper && (!isUserOrPostReport || hasReportType);
    }, message ?? "Must select a report type", code: "reportType");
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

  //* Checks that the string is alpha, and contains only a specific set of special characters, dashes, and underscores, and apostrophes
  AbstractRuleBuilder isValidDisplayName({String? message}) {
    final RegExp pattern = RegExp(r"^[a-zA-Z0-9-_']+$");
    return must((dynamic dyn) => dyn is String && pattern.hasMatch(dyn), message ?? "Must be alphanumeric, and contain only dashes, underscores, and apostrophes", code: "displayName");
  }

  //* Checks that the string is alpha, and contains only a specific set of special characters, dashes, and underscores, and apostrophes
  AbstractRuleBuilder isValidName({String? message}) {
    final RegExp pattern = RegExp(r"^[a-zA-Z-' .À-ÖØ-öø-ÿĀ-ſ-ƀ]+$");
    return must((dynamic dyn) => dyn is String && pattern.hasMatch(dyn), message ?? "Must be alphanumeric, and contain only dashes, underscores, and apostrophes", code: "displayName");
  }

  AbstractRuleBuilder isAlphaNumericWithSpaces({String? message}) {
    return must((dynamic dyn) => dyn is String && RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(dyn), message ?? "Must be alphanumeric", code: "alphaNumeric");
  }

  AbstractRuleBuilder containsNoEmoji({String? message}) {
    return must((dynamic dyn) => dyn is String && !RegExp(r'[^\w\s]', multiLine: true).hasMatch(dyn), message ?? "Must not contain emoji", code: "emoji");
  }

  //* Checks if the object is valid display name length
  AbstractRuleBuilder isDisplayNameLength({String? message}) {
    return must((dynamic dyn) => dyn is String && dyn.length >= 3 && dyn.length <= 15, message ?? "Must be between 3 and 15 characters long", code: "displayNameLength");
  }

  AbstractRuleBuilder isNameLength({String? message}) {
    return must((dynamic dyn) => dyn is String && dyn.length >= 3 && dyn.length <= 30, message ?? "Must be between 3 and 30 characters long", code: "nameLength");
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
