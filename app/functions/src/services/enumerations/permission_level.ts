export enum PermissionLevel {
  None = 0,
  Read = 1 << 0,
  Write = 1 << 1,
  Delete = 1 << 2,
  Admin = 1 << 3,
}
