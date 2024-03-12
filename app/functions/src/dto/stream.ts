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
  reaction_counts: Record<string, number> | undefined;
  time: string | undefined;
  id: string;
  to: string[];
  tags: string[];
  description: string | undefined;
};

export type ReactionEntryJSON = {
  kind: string;
  activity_id: string;
  source_reaction_id: string;
  target_reaction_id: string;
  user_id: string;
  data: any;
  tags: string[];
  time: string;
};

//* This type is the response to the client when requesting batched feed data.
export type FeedBatchedClientResponse = {
  profiles: any[];
  organisations: any[];
  activities: any[];
};

export type GetFeedWindowResult = {
  next: string;
  results: FeedEntry[];
  unread: number;
  unseen: number;
  origin: string;
};
