export enum AuthorizationTarget {
    Profile = 0,
    Post = 1 << 0,
    Comment = 1 << 1,
    Like = 1 << 2,
    Follow = 1 << 3,
    Message = 1 << 4,
    Notification = 1 << 5,
    Connection = 1 << 6,
}