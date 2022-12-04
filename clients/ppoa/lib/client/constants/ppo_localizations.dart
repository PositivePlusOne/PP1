// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const Locale kDefaultLocale = Locale('en', '');
const List<Locale> kSupportedLocales = <Locale>[
  Locale('en', ''),
];

const List<LocalizationsDelegate<dynamic>> kLocalizationDelegates = <LocalizationsDelegate<dynamic>>[
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  AppLocalizations.delegate,
];
