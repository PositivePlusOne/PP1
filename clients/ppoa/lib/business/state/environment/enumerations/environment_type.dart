enum EnvironmentType {
  develop,
  staging,
  production,
  test,
  simulation;

  bool get isDeployedEnvironment => this != EnvironmentType.simulation && this != EnvironmentType.test;
  bool get isMockEnvironment => this == EnvironmentType.simulation || this == EnvironmentType.test;
}
