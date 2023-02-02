// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import 'package:ppoa/client/constants/ppo_localizations.dart';
import 'package:ppoa/resources/resources.dart';
import '../mocks/routing/mock_router.dart';
import 'app_state_helpers.dart';

Future<void> pumpWidgetWithProviderScopeAndServices(Widget widget, AppState? state, WidgetTester tester) async {
  final AppState actualAppState = state ??= AppState.initialState(environmentType: EnvironmentType.test);

  await loadFonts();
  await setTestServiceState(actualAppState, widgetTester: tester);

  final Widget actualWidget = ProviderScope(
    child: MaterialApp(
      home: widget,
      navigatorKey: MockRouter.kNavigationKey,
      localizationsDelegates: kLocalizationDelegates,
      supportedLocales: const <Locale>[
        kDefaultLocale,
      ],
    ),
  );

  await tester.pumpWidget(actualWidget);
}

Future<void> loadFonts() async {
  final List<String> albertSansFontPaths = <String>[
    AlbertSansFonts.albertSansBlack,
    AlbertSansFonts.albertSansBlackItalic,
    AlbertSansFonts.albertSansBold,
    AlbertSansFonts.albertSansBoldItalic,
    AlbertSansFonts.albertSansExtraBold,
    AlbertSansFonts.albertSansExtraBoldItalic,
    AlbertSansFonts.albertSansExtraLight,
    AlbertSansFonts.albertSansExtraLightItalic,
    AlbertSansFonts.albertSansItalic,
    AlbertSansFonts.albertSansLight,
    AlbertSansFonts.albertSansLightItalic,
    AlbertSansFonts.albertSansMedium,
    AlbertSansFonts.albertSansMediumItalic,
    AlbertSansFonts.albertSansRegular,
    AlbertSansFonts.albertSansSemiBold,
    AlbertSansFonts.albertSansSemiBoldItalic,
    AlbertSansFonts.albertSansThin,
    AlbertSansFonts.albertSansThinItalic,
  ];

  for (final String fontPath in albertSansFontPaths) {
    final Future<ByteData> byteData = rootBundle.load(fontPath);
    final FontLoader fontLoader = FontLoader('AlbertSans')..addFont(byteData);
    await fontLoader.load();
  }
}
