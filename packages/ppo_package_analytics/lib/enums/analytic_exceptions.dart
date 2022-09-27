enum AnalyticsException {
  /// Thrown when a analytics provider instance is required but not available.
  /// This is often skipped if the function called is allowed to fail, for example sending analytical data.
  analyticsProviderNotAvailable,

  /// Thrown when an operation to setup an analytics provider is called after already being set up.
  /// For example calling configure twice.
  analyticsProviderAlreadyConfigured,
}
