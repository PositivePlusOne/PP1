import { NotificationAction } from "../../constants/notification_actions";
import { NotificationTopic } from "../../constants/notification_topics";

export class NotificationPayload {
    public key: string = '';
    public sender?: string;
    public receiver: string = '';
    public title?: string;
    public body?: string;
    public topic: NotificationTopic = NotificationTopic.OTHER;
    public action: NotificationAction = NotificationAction.NONE;
    public dismissed?: boolean;
    public extraData?: Record<string, any>;
    public priority: NotificationPriority | null = NotificationPriority.PRIORITY_HIGH;

    constructor(payload?: Partial<NotificationPayload>) {
        if (payload) {
            this.key = payload.key || '';
            this.sender = payload.sender;
            this.receiver = payload.receiver || '';
            this.title = payload.title;
            this.body = payload.body;
            this.topic = payload.topic || NotificationTopic.OTHER;
            this.action = payload.action || NotificationAction.NONE;
            this.dismissed = payload.dismissed;
            this.extraData = payload.extraData;
            this.priority = payload.priority || NotificationPriority.PRIORITY_HIGH;
        }
    }
}


export enum NotificationPriority {
    PRIORITY_LOW = "low",
    PRIORITY_DEFAULT = "default",
    PRIORITY_HIGH = "high",
}

/**
 * Append priority to message payload
 * @param {any} message The message to append the priority to
 * @param {NotificationPriority} priority The priority to append
 * @return {any} The message with the priority appended
 */
export function appendPriorityToMessagePayload(message: any, priority: NotificationPriority | null = null): any {
    if (!priority) {
        priority = NotificationPriority.PRIORITY_HIGH;
    }

    let androidPriority = "default";
    let apnsPriority = "5";

    switch (priority) {
        case NotificationPriority.PRIORITY_LOW:
            androidPriority = "low";
            apnsPriority = "1";
            break;
        case NotificationPriority.PRIORITY_DEFAULT:
            androidPriority = "default";
            apnsPriority = "5";
            break;
        case NotificationPriority.PRIORITY_HIGH:
            androidPriority = "high";
            apnsPriority = "10";
            break;
    }

    message.android = {
        priority: androidPriority,
    };

    message.apns = {
        headers: {
            "apns-priority": apnsPriority,
            "content-available": "1", // Required for background/quit data-only messages on iOS
        },
    };

    return message;
}