//* Used in fields where the user can toggle between multiple states.
//* For example, a button which needs a loading state while talking to the server
enum PositiveTogglableState {
  active,
  activeForcefully, //* Edge cases, such as when the server forces display in app
  inactive,
  loading,
  error;

  factory PositiveTogglableState.fromBool(bool value) {
    return value ? PositiveTogglableState.active : PositiveTogglableState.inactive;
  }
}

extension PositiveTogglableStateExtension on PositiveTogglableState {
  bool get isActive => this == PositiveTogglableState.active || this == PositiveTogglableState.activeForcefully;
}
