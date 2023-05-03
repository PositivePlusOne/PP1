//* Used in fields where the user can toggle between multiple states.
//* For example, a button which needs a loading state while talking to the server
enum PositiveTogglableState {
  active,
  activeForcefully, //* Edge cases, such as when the server forces display in app or unmodifiable fields
  inactive,
  loading, //* Currently waiting for correct inital state to be provided
  updating, //* Awaiting updated state after user has requested a change
  error;

  factory PositiveTogglableState.fromBool(bool value) {
    return value ? PositiveTogglableState.active : PositiveTogglableState.inactive;
  }
}

extension PositiveTogglableStateExtension on PositiveTogglableState {
  bool get isActive => this == PositiveTogglableState.active || this == PositiveTogglableState.activeForcefully;
}
