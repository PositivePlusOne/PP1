export type NotificationPayload = {
    key: string;
    sender: string | null;
    receiver: string;
    title: string | null;
    body: string | null;
    topic: string;
    type: string;
    action: string;
    dismissed: boolean | null;
    extraData: Record<string, any> | null;
    priority: NotificationPriority | null;
};

export enum NotificationPriority {
    PRIORITY_LOW = "low",
    PRIORITY_DEFAULT = "default",
    PRIORITY_HIGH = "high",
}

export function appendPriorityToMessagePayload(message: any, priority: NotificationPriority | null = null) : any {
    if (!priority) {
        priority = NotificationPriority.PRIORITY_DEFAULT;
    }

    var androidPriority = "default";
    var apnsPriority = "5";

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
        },
    };

    return message;
}