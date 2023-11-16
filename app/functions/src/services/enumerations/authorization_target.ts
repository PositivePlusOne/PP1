export enum AuthorizationTarget {
  Unknown = 0,
  Profile = 1 << 0,
  Post = 1 << 1,
  Comment = 1 << 2,
  Like = 1 << 3,
  Follow = 1 << 4,
  Message = 1 << 5,
  Notification = 1 << 6,
  Connection = 1 << 7,
}

export const AuthorizationTargetAll = AuthorizationTarget.Profile | AuthorizationTarget.Post | AuthorizationTarget.Comment | AuthorizationTarget.Like | AuthorizationTarget.Follow | AuthorizationTarget.Message | AuthorizationTarget.Notification | AuthorizationTarget.Connection;
