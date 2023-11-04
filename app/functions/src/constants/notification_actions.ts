export enum NotificationAction {
  NONE = 'none',
  TEST = 'test',
  CONNECTION_REQUEST_ACCEPTED = 'connection_request_accepted',
  CONNECTION_REQUEST_REJECTED = 'connection_request_rejected',
  CONNECTION_REQUEST_SENT = 'connection_request_sent',
  CONNECTION_REQUEST_RECEIVED = 'connection_request_received',
  POST_COMMENTED = 'post_commented',
  POST_COMMENTED_GROUP = 'post_commented_group',
  POST_LIKED = 'post_liked',
  POST_LIKED_GROUP = 'post_liked_group',
  POST_SHARED = 'post_shared',
  POST_SHARED_GROUP = 'post_shared_group',
  POST_BOOKMARKED = 'post_bookmarked',
  POST_BOOKMARKED_GROUP = 'post_bookmarked_group',
  RELATIONSHIP_UPDATED = 'relationship_updated',
}

export const ACTIVITY_NOTIFICATION_TRUNSCATE_LENGTH = 30;