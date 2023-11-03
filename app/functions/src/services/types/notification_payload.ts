import { NotificationAction } from "../../constants/notification_actions";
import { NotificationTopic } from "../../constants/notification_topics";
import { StreamHelpers } from "../../helpers/stream_helpers";


export class NotificationPayloadResponse {
    public payloads: NotificationPayload[] = [];
    public unread_count = 0;
    public unseen_count = 0;
}

/**
 * Notification payload
 * @param {string} id The id of the notification
 * @param {string} sender The sender of the notification
 * @param {string} user_id The user_id of the notification
 * @param {string} title The title of the notification
 * @param {string} title The title of the notification
 * @param {string} body The body of the notification
 * @param {NotificationTopic} topic The topic of the notification
 * @param {NotificationAction} action The action of the notification
 * @param {boolean} hasDismissed Whether the notification has been dismissed
 * @param {Record<string, any>} extra_data Any extra data to send with the notification
 * @param {NotificationPriority} priority The priority of the notification
 */
export class NotificationPayload {
    public id = '';
    public foreign_id = '';
    public user_id = '';
    public sender = '';
    public title = '';
    public body = '';
    public bodyMarkdown = '';
    public icon = '';
    public created_at = StreamHelpers.getCurrentTimestamp();
    public extra_data: Record<string, any> = {};
    public topic: NotificationTopic = NotificationTopic.OTHER;
    public action: NotificationAction = NotificationAction.NONE;
    public priority: NotificationPriority | null = NotificationPriority.PRIORITY_HIGH;

    /**
     * Constructor
     * @param {Partial<NotificationPayload>} payload The payload to construct the notification from
     * @return {NotificationPayload} The constructed notification
     */
    constructor(payload?: Partial<NotificationPayload>) {
        if (payload) {
            this.id = payload.id || '';
            this.foreign_id = payload.foreign_id || '';
            this.user_id = payload.user_id || '';
            this.sender = payload.sender || '';
            this.title = payload.title || '';
            this.body = payload.body || '';
            this.bodyMarkdown = payload.bodyMarkdown || '';
            this.icon = payload.icon || '';
            this.created_at = payload.created_at || StreamHelpers.getCurrentTimestamp();
            this.extra_data = payload.extra_data || {};
            this.topic = payload.topic || NotificationTopic.OTHER;
            this.action = payload.action || NotificationAction.NONE;
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