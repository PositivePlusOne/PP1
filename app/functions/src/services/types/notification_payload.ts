import { NotificationAction } from "../../constants/notification_actions";
import { NotificationTopic } from "../../constants/notification_topics";

/**
 * Notification payload
 * @param {string} key The key of the notification
 * @param {string} sender The sender of the notification
 * @param {string} receiver The receiver of the notification
 * @param {string} title The title of the notification
 * @param {string} body The body of the notification
 * @param {NotificationTopic} topic The topic of the notification
 * @param {NotificationAction} action The action of the notification
 * @param {boolean} hasDismissed Whether the notification has been dismissed
 * @param {Record<string, any>} extraData Any extra data to send with the notification
 * @param {NotificationPriority} priority The priority of the notification
 */
export class NotificationPayload {
    public key = '';
    public sender = '';
    public receiver = '';
    public title = '';
    public body = '';
    public icon = '';
    public topic: NotificationTopic = NotificationTopic.OTHER;
    public action: NotificationAction = NotificationAction.NONE;
    public hasDismissed = false;
    public extraData: Record<string, any> = {};
    public priority: NotificationPriority | null = NotificationPriority.PRIORITY_HIGH;

    /**
     * Constructor
     * @param {Partial<NotificationPayload>} payload The payload to construct the notification from
     * @return {NotificationPayload} The constructed notification
     */
    constructor(payload?: Partial<NotificationPayload>) {
        if (payload) {
            this.key = payload.key || '';
            this.sender = payload.sender || '';
            this.receiver = payload.receiver || '';
            this.title = payload.title || '';
            this.body = payload.body || '';
            this.icon = payload.icon || '';
            this.topic = payload.topic || NotificationTopic.OTHER;
            this.action = payload.action || NotificationAction.NONE;
            this.hasDismissed = payload.hasDismissed || false;
            this.extraData = payload.extraData || {};
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