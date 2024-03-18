import { FlMeta, FlMetaJSON } from "./meta";

export const reactionStatisticsSchemaKey = "reactionStatistics";

export interface ReactionStatisticsJSON {
  _fl_meta_?: FlMetaJSON;
  counts?: Record<string, number>;
  activity_id?: string;
  reaction_id?: string;
  user_id?: string;
}

export class ReactionStatistics {
  _fl_meta_?: FlMeta;
  counts: Record<string, number>;
  activity_id: string;
  reaction_id: string;
  user_id: string;

  constructor(json: ReactionStatisticsJSON) {
    this._fl_meta_ = json._fl_meta_ ? new FlMeta(json._fl_meta_) : undefined;
    this.counts = json.counts ?? {};
    this.activity_id = json.activity_id ?? "";
    this.reaction_id = json.reaction_id ?? "";
    this.user_id = json.user_id ?? "";
  }

  public toJSON(): ReactionStatisticsJSON {
    return {
      counts: this.counts,
      activity_id: this.activity_id,
      reaction_id: this.reaction_id,
      user_id: this.user_id,
    };
  }

  static FromJSONList(jsonList: ReactionStatistics[]): ReactionStatistics[] {
    const list: ReactionStatistics[] = [];
    if (jsonList) {
      jsonList.forEach((json) => {
        list.push(new ReactionStatistics(json));
      });
    }

    return list;
  }
}
