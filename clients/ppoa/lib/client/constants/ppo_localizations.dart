import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const Locale kDefaultLocale = Locale('en', '');
const List<Locale> kSupportedLocales = <Locale>[
  Locale('en', ''),
];

const List<LocalizationsDelegate<dynamic>> kLocalizationDelegates = <LocalizationsDelegate<dynamic>>[
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];
