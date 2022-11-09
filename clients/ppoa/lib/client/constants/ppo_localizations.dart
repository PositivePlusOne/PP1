import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const Locale kDefaultLocale = Locale('en', 'GB');
const List<Locale> kSupportedLocales = <Locale>[
  Locale('en', 'GB'),
];

const List<LocalizationsDelegate<dynamic>> kLocalizationDelegates = <LocalizationsDelegate<dynamic>>[
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];
