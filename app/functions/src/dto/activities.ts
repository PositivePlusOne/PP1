import { Media, MediaJSON } from "./media";
import { Mention, MentionJSON } from "./mentions";
import { FlMeta, FlMetaJSON } from "./meta";

export const activitySchemaKey = 'activities';

/**
 * The type of activity
 * @export
 * @enum {number}
 * @property {string} Post A post
 * @property {string} Like A like
 * @property {string} Comment A comment
 * @property {string} Share A share
 * @property {string} Bookmark A bookmark
 */
export enum ActivityActionVerb {
  Post = "post",
  Like = "like",
  Comment = "comment",
  Share = "share",
  Bookmark = "bookmark",
}

/**
 * The JSON representation of an activity
 * @export
 * @interface ActivityJSON
 * @property {FlMetaJSON} [_fl_meta_]
 * @property {string} [foreignKey]
 * @property {ActivityGeneralConfigurationJSON} [generalConfiguration]
 * @property {ActivitySecurityConfigurationJSON} [securityConfiguration]
 * @property {ActivityEventConfigurationJSON} [eventConfiguration]
 * @property {ActivityPricingInformationJSON} [pricingInformation]
 * @property {ActivityPublisherInformationJSON} [publisherInformation]
 * @property {ActivityEnrichmentConfigurationJSON} [enrichmentConfiguration]
 * @property {MediaJSON[]} [media]
 */
export interface ActivityJSON {
  _fl_meta_?: FlMetaJSON;
  generalConfiguration?: ActivityGeneralConfigurationJSON;
  securityConfiguration?: ActivitySecurityConfigurationJSON;
  eventConfiguration?: ActivityEventConfigurationJSON;
  pricingInformation?: ActivityPricingInformationJSON;
  publisherInformation?: ActivityPublisherInformationJSON;
  enrichmentConfiguration?: ActivityEnrichmentConfigurationJSON;
  media?: MediaJSON[];
}

/**
 * An activity
 * @export
 * @class Activity
 * @property {FlMeta} [_fl_meta_]
 * @property {ActivityGeneralConfiguration} [generalConfiguration]
 * @property {ActivitySecurityConfiguration} [securityConfiguration]
 * @property {ActivityEventConfiguration} [eventConfiguration]
 * @property {ActivityPricingInformation} [pricingInformation]
 * @property {ActivityPublisherInformation} [publisherInformation]
 * @property {ActivityEnrichmentConfiguration} [enrichmentConfiguration]
 * @property {Media[]} media
 */
export class Activity {
  _fl_meta_?: FlMeta;
  generalConfiguration?: ActivityGeneralConfiguration;
  securityConfiguration?: ActivitySecurityConfiguration;
  eventConfiguration?: ActivityEventConfiguration;
  pricingInformation?: ActivityPricingInformation;
  publisherInformation?: ActivityPublisherInformation;
  enrichmentConfiguration?: ActivityEnrichmentConfiguration;
  media: Media[];

  constructor(json: ActivityJSON) {
    this._fl_meta_ = json._fl_meta_ && new FlMeta(json._fl_meta_);
    this.generalConfiguration = json.generalConfiguration && new ActivityGeneralConfiguration(json.generalConfiguration);
    this.securityConfiguration = json.securityConfiguration && new ActivitySecurityConfiguration(json.securityConfiguration);
    this.eventConfiguration = json.eventConfiguration && new ActivityEventConfiguration(json.eventConfiguration);
    this.pricingInformation = json.pricingInformation && new ActivityPricingInformation(json.pricingInformation);
    this.publisherInformation = json.publisherInformation && new ActivityPublisherInformation(json.publisherInformation);
    this.enrichmentConfiguration = json.enrichmentConfiguration && new ActivityEnrichmentConfiguration(json.enrichmentConfiguration);
    this.media = json.media ? json.media.map((item) => new Media(item)) : [];
  }
}

/**
 * The type of activity
 * @export
 * @enum {number}
 * @property {string} Post A post
 * @property {string} Event An event
 * @property {string} Clip A clip
 * @property {string} Repost A repost
 */
export type ActivityGeneralConfigurationType = 'post' | 'event' | 'clip' | 'repost';

/**
 * The style of activity
 * @export
 * @enum {number}
 * @property {string} Markdown Markdown
 * @property {string} Text Text
 */
export type ActivityGeneralConfigurationStyle = 'markdown' | 'text';

/**
 * The JSON representation of an activity general configuration
 * @export
 * @interface ActivityGeneralConfigurationJSON
 * @property {ActivityGeneralConfigurationType} [type]
 * @property {ActivityGeneralConfigurationStyle} [style]
 * @property {string} [content] The content of the activity (markdown or text)
 */
export interface ActivityGeneralConfigurationJSON {
  type?: ActivityGeneralConfigurationType;
  style?: ActivityGeneralConfigurationStyle;
  content?: string;
}

/**
 * General configuration for an activity
 * @export
 * @class ActivityGeneralConfiguration
 * @property {ActivityGeneralConfigurationType} type
 * @property {ActivityGeneralConfigurationStyle} style
 * @property {string} content The content of the activity (markdown or text)
 */
export class ActivityGeneralConfiguration {
  type: ActivityGeneralConfigurationType;
  style: ActivityGeneralConfigurationStyle;
  content: string;

  constructor(json: ActivityGeneralConfigurationJSON) {
    this.type = json.type || 'post';
    this.style = json.style || 'text';
    this.content = json.content || '';
  }
}

/**
 * The mode for an activity security configuration.
 * These dictate what tag feeds the activity will appear in.
 * @export
 * @enum {number}
 * @property {string} Public Public
 * @property {string} FollowersAndConnections Followers and connections
 * @property {string} Connections Connections
 * @property {string} Private Private
 */
export type ActivitySecurityConfigurationMode = 'public' | 'followers_and_connections' | 'connections' | 'private';

/**
 * The JSON representation of an activity security configuration
 * @export
 * @interface ActivitySecurityConfigurationJSON
 * @property {string} [context]
 * @property {ActivitySecurityConfigurationMode} [viewMode]
 * @property {ActivitySecurityConfigurationMode} [reactionMode]
 * @property {ActivitySecurityConfigurationMode} [shareMode]
 */
export interface ActivitySecurityConfigurationJSON {
  context?: string;
  viewMode?: ActivitySecurityConfigurationMode;
  reactionMode?: ActivitySecurityConfigurationMode;
  shareMode?: ActivitySecurityConfigurationMode;
}

/**
 * Security configuration for an activity
 * @export
 * @class ActivitySecurityConfiguration
 * @property {string} context
 * @property {ActivitySecurityConfigurationMode} viewMode
 * @property {ActivitySecurityConfigurationMode} reactionMode
 * @property {ActivitySecurityConfigurationMode} shareMode
 */
export class ActivitySecurityConfiguration {
  context: string;
  viewMode: ActivitySecurityConfigurationMode;
  reactionMode: ActivitySecurityConfigurationMode;
  shareMode: ActivitySecurityConfigurationMode;

  constructor(json: ActivitySecurityConfigurationJSON) {
    this.context = json.context || '';
    this.viewMode = json.viewMode || 'private';
    this.reactionMode = json.reactionMode || 'private';
    this.shareMode = json.shareMode || 'private';
  }
}

/**
 * The JSON representation of an activity schedule
 * @export
 * @interface ActivityScheduleJSON
 * @property {string} [recurrenceRule] An IEEE RRULE string
 * @property {Date} [start] The start date of the activity
 * @property {Date} [end] The end date of the activity
 */
export interface ActivityScheduleJSON {
  recurrenceRule?: string;
  start?: Date;
  end?: Date;
}

/**
 * A schedule for an activity
 * @export
 * @class ActivitySchedule
 * @property {string} recurrenceRule An IEEE RRULE string
 * @property {Date} [start] The start date of the activity
 * @property {Date} [end] The end date of the activity
 */
export class ActivitySchedule {
  recurrenceRule: string;
  start?: Date;
  end?: Date;

  constructor(json: ActivityScheduleJSON) {
    this.recurrenceRule = json.recurrenceRule || '';
    this.start = json.start;
    this.end = json.end;
  }
}

/**
 * The JSON representation of an activity event configuration
 * @export
 * @interface ActivityEventConfigurationJSON
 * @property {Record<string, any>} [venue]
 * @property {string} [name]
 * @property {ActivityScheduleJSON} [schedule]
 * @property {string} [location]
 * @property {number} [popularityScore]
 * @property {boolean} [isCancelled]
 */
export interface ActivityEventConfigurationJSON {
  venue?: Record<string, any>;
  name?: string;
  schedule?: ActivityScheduleJSON;
  location?: string;
  popularityScore?: number;
  isCancelled?: boolean;
}

/**
 * Configuration for an activity event
 * @export
 * @class ActivityEventConfiguration
 * @property {Record<string, any>} [venue]
 * @property {string} name
 * @property {ActivitySchedule} [schedule]
 * @property {string} location
 * @property {number} popularityScore
 * @property {boolean} isCancelled
 */
export class ActivityEventConfiguration {
  venue?: any;
  name: string;
  schedule?: ActivitySchedule;
  location: string;
  popularityScore: number;
  isCancelled: boolean;

  constructor(json: ActivityEventConfigurationJSON) {
    this.venue = json.venue;
    this.name = json.name || '';
    this.schedule = json.schedule && new ActivitySchedule(json.schedule);
    this.location = json.location || '';
    this.popularityScore = json.popularityScore || 0;
    this.isCancelled = json.isCancelled || false;
  }
}

/**
 * The pricing strategy for an activity
 * @export
 * @enum {number}
 * @property {string} Persons1 Persons 1 strategy (cost per person)
 */
export type ActivityPricingExternalStoreInformationPricingStrategy = 'persons_1';

/**
 * The JSON representation of an activity pricing external store information
 * @export
 * @interface ActivityPricingExternalStoreInformationJSON
 * @property {string} [costExact]
 * @property {string} [costMinimum]
 * @property {string} [costMaximum]
 * @property {ActivityPricingExternalStoreInformationPricingStrategy} [pricingStrategy]
 */
export interface ActivityPricingExternalStoreInformationJSON {
  costExact?: string;
  costMinimum?: string;
  costMaximum?: string;
  pricingStrategy?: ActivityPricingExternalStoreInformationPricingStrategy;
}

/**
 * Pricing information for an activity
 * @export
 * @class ActivityPricingExternalStoreInformation
 * @property {string} costExact
 * @property {string} costMinimum
 * @property {string} costMaximum
 * @property {ActivityPricingExternalStoreInformationPricingStrategy} pricingStrategy
 */
export class ActivityPricingExternalStoreInformation {
  costExact: string;
  costMinimum: string;
  costMaximum: string;
  pricingStrategy: ActivityPricingExternalStoreInformationPricingStrategy;

  constructor(json: ActivityPricingExternalStoreInformationJSON) {
    this.costExact = json.costExact || '';
    this.costMinimum = json.costMinimum || '';
    this.costMaximum = json.costMaximum || '';
    this.pricingStrategy = json.pricingStrategy || 'persons_1';
  }
}

/**
 * The JSON representation of an activity pricing information
 * @export
 * @interface ActivityPricingInformationJSON
 * @property {string} [productId]
 * @property {ActivityPricingExternalStoreInformationJSON} [externalStoreInformation]
 */
export interface ActivityPricingInformationJSON {
  productId?: string;
  externalStoreInformation?: ActivityPricingExternalStoreInformationJSON;
}

/**
 * Pricing information for an activity
 * @export
 * @class ActivityPricingInformation
 * @property {string} productId
 * @property {ActivityPricingExternalStoreInformation} [externalStoreInformation]
 */
export class ActivityPricingInformation {
  productId: string;
  externalStoreInformation?: ActivityPricingExternalStoreInformation;

  constructor(json: ActivityPricingInformationJSON) {
    this.productId = json.productId || '';
    this.externalStoreInformation = json.externalStoreInformation && new ActivityPricingExternalStoreInformation(json.externalStoreInformation);
  }
}

/**
 * The JSON representation of an activity publisher information
 * @export
 * @interface ActivityPublisherInformationJSON
 * @property {string} [foreignKey] The foreign key of the publisher (Usually the user ID)
 */
export interface ActivityPublisherInformationJSON {
  foreignKey?: string;
  originFeed?: string;
}

/**
 * Publisher information for an activity
 * @export
 * @class ActivityPublisherInformation
 * @property {string} foreignKey The foreign key of the publisher (Usually the user ID)
 */
export class ActivityPublisherInformation {
  foreignKey: string;
  originFeed: string;

  constructor(json: ActivityPublisherInformationJSON) {
    this.foreignKey = json.foreignKey || '';
    this.originFeed = json.originFeed || '';
  }
}

/**
 * The JSON representation of an activity enrichment configuration
 * @export
 * @interface ActivityEnrichmentConfigurationJSON
 * @property {string} [title]
 * @property {string[]} [tags]
 * @property {boolean} [isSensitive]
 * @property {string} [publishLocation]
 * @property {MentionJSON[]} [mentions]
 */
export interface ActivityEnrichmentConfigurationJSON {
  title?: string;
  tags?: string[];
  isSensitive?: boolean;
  publishLocation?: string;
  mentions?: MentionJSON[];
}

/**
 * Enrichment configuration for an activity
 * @export
 * @class ActivityEnrichmentConfiguration
 * @property {string} title
 * @property {string[]} tags
 * @property {boolean} isSensitive
 * @property {string} publishLocation
 * @property {Mention[]} mentions
 * @property {string} [foreignKey] The foreign key of the publisher (Usually the user ID)
 */
export class ActivityEnrichmentConfiguration {
  title: string;
  tags: string[];
  isSensitive: boolean;
  publishLocation: string;
  mentions: Mention[];

  constructor(json: ActivityEnrichmentConfigurationJSON) {
    this.title = json.title || '';
    this.tags = json.tags || [];
    this.isSensitive = json.isSensitive || false;
    this.publishLocation = json.publishLocation || '';
    this.mentions = json.mentions ? json.mentions.map((m) => new Mention(m)) : [];
  }
}