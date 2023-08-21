import { ReactionAPIResponse, UR } from "getstream";
import { StreamActorType } from "../services/enumerations/actors";
import { CommentJSON } from "./comments";
import { Media, MediaJSON } from "./media";
import { Mention, MentionJSON } from "./mentions";

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
  user_id: string;
  data: any;
  tags: string[];
}

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
};
