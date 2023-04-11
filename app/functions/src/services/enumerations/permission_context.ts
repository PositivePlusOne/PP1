export enum PermissionContext {
  None = 0,
  Anonymous = 1 << 0,
  Connected = 1 << 1,
  Following = 1 << 2,
  Owner = 1 << 3,
  Admin = 1 << 4,
}

export const PermissionContextDeterministic =
  PermissionContext.Owner |
  PermissionContext.Admin |
  PermissionContext.Connected |
  PermissionContext.Following |
  PermissionContext.Anonymous;

export const PermissionContextPrivate =
  PermissionContext.Owner | PermissionContext.Admin;
