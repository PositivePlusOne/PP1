// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:app/resources/resources.dart';

void main() {
  test('albert_sans_fonts assets test', () {
    expect(File(AlbertSansFonts.albertSansBlack).existsSync(), isTrue);
    expect(File(AlbertSansFonts.albertSansBlackItalic).existsSync(), isTrue);
    expect(File(AlbertSansFonts.albertSansBold).existsSync(), isTrue);
    expect(File(AlbertSansFonts.albertSansBoldItalic).existsSync(), isTrue);
    expect(File(AlbertSansFonts.albertSansExtraBold).existsSync(), isTrue);
    expect(
        File(AlbertSansFonts.albertSansExtraBoldItalic).existsSync(), isTrue);
    expect(File(AlbertSansFonts.albertSansExtraLight).existsSync(), isTrue);
    expect(
        File(AlbertSansFonts.albertSansExtraLightItalic).existsSync(), isTrue);
    expect(File(AlbertSansFonts.albertSansItalic).existsSync(), isTrue);
    expect(File(AlbertSansFonts.albertSansLight).existsSync(), isTrue);
    expect(File(AlbertSansFonts.albertSansLightItalic).existsSync(), isTrue);
    expect(File(AlbertSansFonts.albertSansMedium).existsSync(), isTrue);
    expect(File(AlbertSansFonts.albertSansMediumItalic).existsSync(), isTrue);
    expect(File(AlbertSansFonts.albertSansRegular).existsSync(), isTrue);
    expect(File(AlbertSansFonts.albertSansSemiBold).existsSync(), isTrue);
    expect(File(AlbertSansFonts.albertSansSemiBoldItalic).existsSync(), isTrue);
    expect(File(AlbertSansFonts.albertSansThin).existsSync(), isTrue);
    expect(File(AlbertSansFonts.albertSansThinItalic).existsSync(), isTrue);
  });
}
