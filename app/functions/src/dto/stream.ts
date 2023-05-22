import { StreamActorType } from "../services/enumerations/actors";

export type DefaultGenerics = {
    id: string;
    object: string;
    actor: string;
};

export type EnrichedActivity<T> = {
    id: string;
    object: T;
    actor: string;
};

export type FeedEntry = {
    actor: string;
    actorType: StreamActorType | undefined;
    verb: string;
    object: string;
    foreign_id: string;
    time: string | undefined;
    id: string;
}

//* This type is the response to the client when requesting batched feed data.
export type FeedBatchedClientResponse = {
    profiles: any[];
    organisations: any[];
    activities: any[];
}

export type GetFeedWindowResult = {
    next: string;
    results: FeedEntry[];
    unread: number;
    unseen: number;
};