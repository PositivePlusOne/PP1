// Project imports:
import 'package:ppoa/business/state/app_state.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import 'package:ppoa/business/state/environment/models/environment.dart';

class MockStateBuilder {
  AppState state = const AppState(
    environment: Environment(type: EnvironmentType.test),
  );

  void withEnvironmentType(EnvironmentType environmentType) {
    state = state.copyWith(
      environment: state.environment.copyWith(type: environmentType),
    );
  }
}
