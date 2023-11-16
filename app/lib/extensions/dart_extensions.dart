// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:app/constants/country_constants.dart';

extension ListExtensions<T> on List<T> {
  T getElementAtModuloIndex(int index) {
    return this[index % length];
  }
}

extension StringExtensions on String? {
  String get asHandle {
    const String kDefaultHandle = '@Anonymous';
    if (this == null || this!.isEmpty) {
      return kDefaultHandle;
    }

    if (this!.startsWith('@')) {
      return this!;
    }

    return '@$this';
  }

  String get pascalToSpaced {
    String str = this ?? '';

    if (str.isEmpty) {
      return str;
    }

    str = str.replaceAllMapped(RegExp(r'[A-Z]'), (Match match) => ' ${match.group(0)}');
    str = str.replaceAll(RegExp(r'\s+'), ' ');
    str = str.trim();

    return str;
  }

  Size getTextSize(TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: this, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  String get asDateString {
    try {
      final DateTime dateTime = DateTime.parse(this ?? '');
      return kDefaultDateFormat.format(dateTime);
    } catch (_) {
      return '';
    }
  }

  String get age {
    try {
      final DateTime dateTime = DateTime.parse(this ?? '');
      final Duration differenceDuration = DateTime.now().difference(dateTime);
      final int age = (differenceDuration.inDays / 365).floor();
      return age.toString();
    } catch (_) {
      return '';
    }
  }

  //? Can we get context or localisations
  String asDateDifference(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    try {
      String recentDate = "";
      final DateTime dateTime = DateTime.parse(this ?? '');
      Duration differenceDuration = DateTime.now().difference(dateTime);

      //! This could be a dart 3.0 switch statement, however complex switches are not working on my machine
      //TODO(s): change to complex switch statements, and clean up rounding errors due to leap years and differing days per month

      if (differenceDuration.inMinutes < 2) {
        recentDate = localizations.shared_time_just_now;
      }
      if (differenceDuration.inMinutes < 60 && differenceDuration.inMinutes >= 2) {
        recentDate = localizations.shared_time_minutes_ago(differenceDuration.inMinutes);
      }
      if (differenceDuration.inMinutes >= 60 && differenceDuration.inHours < 2) {
        recentDate = localizations.shared_time_one_hour_ago;
      }
      if (differenceDuration.inHours >= 2 && differenceDuration.inHours < 24) {
        recentDate = localizations.shared_time_hours_ago(differenceDuration.inHours);
      }
      if (differenceDuration.inDays >= 1 && differenceDuration.inDays < 2) {
        recentDate = localizations.shared_time_one_day_ago;
      }
      if (differenceDuration.inDays >= 2 && differenceDuration.inDays < 7) {
        recentDate = localizations.shared_time_days_ago(differenceDuration.inDays);
      }
      if (differenceDuration.inDays >= 7 && differenceDuration.inDays < 14) {
        recentDate = localizations.shared_time_one_week_ago;
      }
      if (differenceDuration.inDays > 14 && differenceDuration.inDays <= 30) {
        recentDate = localizations.shared_time_weeks_ago(differenceDuration.inDays ~/ 7);
      }
      if (differenceDuration.inDays > 30 && differenceDuration.inDays <= 60) {
        recentDate = localizations.shared_time_one_month_ago;
      }
      if (differenceDuration.inDays > 60 && differenceDuration.inDays <= 365) {
        recentDate = localizations.shared_time_months_ago(differenceDuration.inDays ~/ 30);
      }
      if (differenceDuration.inDays > 365 && differenceDuration.inDays <= 730) {
        recentDate = localizations.shared_time_one_year_ago;
      }
      if (differenceDuration.inDays > 730) {
        recentDate = localizations.shared_time_years_ago(differenceDuration.inDays ~/ 365);
      }

      return recentDate;
    } catch (_) {
      return '';
    }
  }
}

extension StringListExtensions on List<String> {
  String get parseAsIdentifier {
    final List<String> split = [...this]..sort();
    return split.join('-');
  }
}
