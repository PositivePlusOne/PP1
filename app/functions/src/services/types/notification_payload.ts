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
    public group_id = '';
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
            this.group_id = payload.group_id || '';
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