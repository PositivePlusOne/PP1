// Project imports:
import 'package:ppoa/business/environment/enumerations/environment_type.dart';
import 'package:ppoa/business/environment/models/environment.dart';
import 'package:ppoa/business/state/app_state.dart';

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
