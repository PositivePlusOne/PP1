export type CreateConversationRequest = {
  members: string[];
};

export type SendEventMessage = {
  eventType: "user_removed" | "user_added" | "channel_frozen" | "channel_unfrozen";
  channelId: string;
  text: string;
  mentionedUsers?: string[];
};

export type FreezeChannelRequest = {
  channelId: string;
  /** The user that created the freeze request */
  userId: string;
  /** The message text to show */
  text: string;
};
export type UnfreezeChannelRequest = {
  channelId: string;
};
