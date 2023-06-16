export type CreateConversationRequest = {
  members: string[];
};

export type SendEventMessage = {
  channelId: string;
  text: string;
  mentionedUsers?: string[];
};

export type ArchiveMembers = {
  channelId: string;
  members: string[];
};
