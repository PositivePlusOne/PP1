// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:ppoa/resources/resources.dart';

void main() {
  test('albert_sans_fonts assets test', () {
    expect(File(AlbertSansFonts.albertSansBlack).existsSync(), true);
    expect(File(AlbertSansFonts.albertSansBlackItalic).existsSync(), true);
    expect(File(AlbertSansFonts.albertSansBold).existsSync(), true);
    expect(File(AlbertSansFonts.albertSansBoldItalic).existsSync(), true);
    expect(File(AlbertSansFonts.albertSansExtraBold).existsSync(), true);
    expect(File(AlbertSansFonts.albertSansExtraBoldItalic).existsSync(), true);
    expect(File(AlbertSansFonts.albertSansExtraLight).existsSync(), true);
    expect(File(AlbertSansFonts.albertSansExtraLightItalic).existsSync(), true);
    expect(File(AlbertSansFonts.albertSansItalic).existsSync(), true);
    expect(File(AlbertSansFonts.albertSansLight).existsSync(), true);
    expect(File(AlbertSansFonts.albertSansLightItalic).existsSync(), true);
    expect(File(AlbertSansFonts.albertSansMedium).existsSync(), true);
    expect(File(AlbertSansFonts.albertSansMediumItalic).existsSync(), true);
    expect(File(AlbertSansFonts.albertSansRegular).existsSync(), true);
    expect(File(AlbertSansFonts.albertSansSemiBold).existsSync(), true);
    expect(File(AlbertSansFonts.albertSansSemiBoldItalic).existsSync(), true);
    expect(File(AlbertSansFonts.albertSansThin).existsSync(), true);
    expect(File(AlbertSansFonts.albertSansThinItalic).existsSync(), true);
  });
}
