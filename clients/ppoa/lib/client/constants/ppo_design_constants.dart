import 'package:flutter/material.dart';

final ThemeData ppoThemeLight = ThemeData(
  brightness: Brightness.light,
  textTheme: ppoThemeText,
);

final ThemeData ppoThemeDark = ThemeData(
  brightness: Brightness.dark,
  textTheme: ppoThemeText,
);

const TextTheme ppoThemeText = TextTheme(
  headline1: TextStyle(fontFamily: 'AlbertSans', fontSize: 102, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  headline2: TextStyle(fontFamily: 'AlbertSans', fontSize: 64, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  headline3: TextStyle(fontFamily: 'AlbertSans', fontSize: 51, fontWeight: FontWeight.w400),
  headline4: TextStyle(fontFamily: 'AlbertSans', fontSize: 36, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headline5: TextStyle(fontFamily: 'AlbertSans', fontSize: 25, fontWeight: FontWeight.w400),
  headline6: TextStyle(fontFamily: 'AlbertSans', fontSize: 21, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  subtitle1: TextStyle(fontFamily: 'AlbertSans', fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  subtitle2: TextStyle(fontFamily: 'AlbertSans', fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyText1: TextStyle(fontFamily: 'AlbertSans', fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyText2: TextStyle(fontFamily: 'AlbertSans', fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  button: TextStyle(fontFamily: 'AlbertSans', fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  caption: TextStyle(fontFamily: 'AlbertSans', fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  overline: TextStyle(fontFamily: 'AlbertSans', fontSize: 11, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);
