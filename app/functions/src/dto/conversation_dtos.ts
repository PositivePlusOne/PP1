export type CreateConversationRequest = {
  members: string[];
};

export type SendEventMessage = {
  channelId: string;
  text: string;
  mentionedUsers?: string[];
};

export type FreezeChannelRequest = {
  channelId: string;
  /** The message text to show */
  text: string;
};
