import 'package:mocktail/mocktail.dart';
import 'package:ppo_package_analytics/ppo_package_analytics.dart';

class MockMixpanelWrapper extends Mock implements MixpanelWrapper {
  MockMixpanelWrapper() {
    when(() => initializeMixpanel(any(), any())).thenAnswer((_) async => MockMixpanel());
  }
}
