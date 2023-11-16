// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/constants/country_constants.dart';

part 'country.freezed.dart';

@freezed
class Country with _$Country {
  const factory Country({
    required String isoCode,
    required String iso3Code,
    required String phoneCode,
    required String name,
  }) = _Country;

  static Country? fromPhoneCode(String phoneCode) {
    final String phoneCodeWithoutPlus = phoneCode.startsWith('+') ? phoneCode.substring(1) : phoneCode;
    return kCountryList.firstWhereOrNull((Country country) => country.phoneCode == phoneCodeWithoutPlus);
  }

  static Country fromContext(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);
    return fromLocale(locale);
  }

  static Country fromLocale(Locale locale) {
    final Country? foundCountry = kCountryList.firstWhereOrNull((Country country) => country.isoCode == locale.countryCode);

    if (foundCountry != null) {
      return foundCountry;
    }

    return kCountryList.firstWhere((element) => element.isoCode == kDefaultCountryIsoCode);
  }
}
