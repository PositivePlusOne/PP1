export type NotificationPayload = {
    key: string;
    sender: string | null;
    receiver: string;
    title: string | null;
    body: string | null;
    topic: string;
    type: string;
    action: string;
    hasDismissed: boolean | null;
};