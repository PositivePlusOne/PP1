export type CreateConversationRequest = {
  members: string[];
  senderId: string;
};

export type SendEventMessage = {
  eventType: "user_removed" | "user_added" | "channel_frozen" | "channel_unfrozen";
  channelId: string;
  text: string;
  mentionedUsers?: string[];
  senderId: string;
};

export type FreezeChannelRequest = {
  channelId: string;
  text: string;
  senderId: string;
};

export type UnfreezeChannelRequest = {
  channelId: string;
  senderId: string;
};
