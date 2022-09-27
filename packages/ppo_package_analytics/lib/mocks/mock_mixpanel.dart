import 'package:ppo_package_analytics/ppo_package_analytics.dart';
import 'package:mocktail/mocktail.dart';

class MockMixpanel extends Mock implements Mixpanel {
  MockMixpanel() {
    when(() => flush()).thenAnswer((_) async {});
  }

  void mockCaptureTrack() {
    when(() => track(any(), properties: captureAny(named: 'properties'))).thenReturn(null);
  }
}
