export type CreateConversationRequest = {
    members: string[];
};

export type SystemEventType = "leave";

export type SendEventMessage = {
    channelId: string,
    eventType: SystemEventType,
    extra: any,
}
