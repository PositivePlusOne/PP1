// Package imports:
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockMixpanel extends Mock implements Mixpanel {
  MockMixpanel() {
    registerFallbackValue(this);
    when(() => track(any(), properties: any(named: 'properties'))).thenAnswer((_) async {});
    when(() => track(any())).thenAnswer((_) async {});
  }
}
