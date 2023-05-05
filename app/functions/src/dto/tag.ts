export type Tag = {
    key: string;
    fallback: string;
    promoted: boolean;
    localizations: TagLocalization[];
}

export type TagLocalization = {
    locale: string;
    value: string;
}

export function isTagLocalization(obj: any): obj is TagLocalization {
    return (
        obj !== null &&
        typeof obj === 'object' &&
        typeof obj.locale === 'string' &&
        typeof obj.value === 'string'
    );
}

export function isTag(obj: any): obj is Tag {
    return (
        obj !== null &&
        typeof obj === 'object' &&
        typeof obj.key === 'string' &&
        typeof obj.fallback === 'string' &&
        typeof obj.promoted === 'boolean' &&
        Array.isArray(obj.localizations) &&
        obj.localizations.every(isTagLocalization)
    );
}

export function resolveTag(input: any): Tag | null {
    if (isTag(input)) {
        return input;
    }

    return null;
}
