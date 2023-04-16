enum PositiveNotificationType {
  typeDefault("TYPE_DEFAULT"),
  typeStored("TYPE_STORED"),
  typeData("TYPE_DATA");

  const PositiveNotificationType(this.value);
  final String value;
}
