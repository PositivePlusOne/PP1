import { StreamActorType } from "../services/enumerations/actors";

export type FeedEntry = {
    actor: string;
    actorType: StreamActorType;
    verb: string;
    object: string;
    foreign_id: string;
    time: string;
    id: string;
}

//* This type is the response to the client when requesting batched feed data.
export type FeedBatchedClientResponse = {
    profiles: any[];
    organisations: any[];
    activities: any[];
}