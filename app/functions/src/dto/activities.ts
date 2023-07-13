import { Media, MediaJSON } from "./media";
import { FlMeta, FlMetaJSON } from "./meta";

export enum ActivityActionVerb {
  Post = "post",
  Like = "like",
  Comment = "comment",
  Share = "share",
  Bookmark = "bookmark",
}

export interface ActivityJSON {
  _fl_meta_?: FlMetaJSON;
  foreignKey?: string;
  generalConfiguration?: ActivityGeneralConfigurationJSON;
  securityConfiguration?: ActivitySecurityConfigurationJSON;
  eventConfiguration?: ActivityEventConfigurationJSON;
  pricingInformation?: ActivityPricingInformationJSON;
  publisherInformation?: ActivityPublisherInformationJSON;
  enrichmentConfiguration?: ActivityEnrichmentConfigurationJSON;
  media?: MediaJSON[];
}

export class Activity {
  flMeta?: FlMeta;
  foreignKey: string;
  generalConfiguration?: ActivityGeneralConfiguration;
  securityConfiguration?: ActivitySecurityConfiguration;
  eventConfiguration?: ActivityEventConfiguration;
  pricingInformation?: ActivityPricingInformation;
  publisherInformation?: ActivityPublisherInformation;
  enrichmentConfiguration?: ActivityEnrichmentConfiguration;
  media: Media[];

  constructor(json: ActivityJSON) {
      this.flMeta = json._fl_meta_ && new FlMeta(json._fl_meta_);
      this.foreignKey = json.foreignKey || '';
      this.generalConfiguration = json.generalConfiguration && new ActivityGeneralConfiguration(json.generalConfiguration);
      this.securityConfiguration = json.securityConfiguration && new ActivitySecurityConfiguration(json.securityConfiguration);
      this.eventConfiguration = json.eventConfiguration && new ActivityEventConfiguration(json.eventConfiguration);
      this.pricingInformation = json.pricingInformation && new ActivityPricingInformation(json.pricingInformation);
      this.publisherInformation = json.publisherInformation && new ActivityPublisherInformation(json.publisherInformation);
      this.enrichmentConfiguration = json.enrichmentConfiguration && new ActivityEnrichmentConfiguration(json.enrichmentConfiguration);
      this.media = json.media ? json.media.map(item => new Media(item)) : [];
  }
}

export type ActivityGeneralConfigurationType = 'post' | 'event' | 'clip' | 'repost';
export type ActivityGeneralConfigurationStyle = 'markdown' | 'text';

export interface ActivityGeneralConfigurationJSON {
  type?: ActivityGeneralConfigurationType;
  style?: ActivityGeneralConfigurationStyle;
  content?: string;
}

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

export type ActivitySecurityConfigurationMode = 'public' | 'followers_and_connections' | 'connections' | 'private';

export interface ActivitySecurityConfigurationJSON {
  context?: string;
  viewMode?: ActivitySecurityConfigurationMode;
  reactionMode?: ActivitySecurityConfigurationMode;
  shareMode?: ActivitySecurityConfigurationMode;
}

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

export interface ActivityScheduleJSON {
  recurrenceRule?: string;
  start?: Date;
  end?: Date;
}

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

export interface ActivityEventConfigurationJSON {
  venue?: any;
  name?: string;
  schedule?: ActivityScheduleJSON;
  location?: string;
  popularityScore?: number;
  isCancelled?: boolean;
}

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

export type ActivityPricingExternalStoreInformationPricingStrategy = 'persons_1';

export interface ActivityPricingExternalStoreInformationJSON {
  costExact?: string;
  costMinimum?: string;
  costMaximum?: string;
  pricingStrategy?: ActivityPricingExternalStoreInformationPricingStrategy;
}

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

export interface ActivityPricingInformationJSON {
  productId?: string;
  externalStoreInformation?: ActivityPricingExternalStoreInformationJSON;
}

export class ActivityPricingInformation {
  productId: string;
  externalStoreInformation?: ActivityPricingExternalStoreInformation;

  constructor(json: ActivityPricingInformationJSON) {
    this.productId = json.productId || '';
    this.externalStoreInformation = json.externalStoreInformation && new ActivityPricingExternalStoreInformation(json.externalStoreInformation);
  }
}

export interface ActivityPublisherInformationJSON {
  foreignKey?: string;
}

export class ActivityPublisherInformation {
  foreignKey: string;

  constructor(json: ActivityPublisherInformationJSON) {
    this.foreignKey = json.foreignKey || '';
  }
}

export interface ActivityMentionJSON {
  startIndex?: number;
  endIndex?: number;
  organisation?: string;
  user?: string;
  activity?: string;
  tag?: string;
}

export class ActivityMention {
  startIndex: number;
  endIndex: number;
  organisation: string;
  user: string;
  activity: string;
  tag: string;

  constructor(json: ActivityMentionJSON) {
    this.startIndex = json.startIndex || -1;
    this.endIndex = json.endIndex || -1;
    this.organisation = json.organisation || '';
    this.user = json.user || '';
    this.activity = json.activity || '';
    this.tag = json.tag || '';
  }
}

export interface ActivityEnrichmentConfigurationJSON {
  title?: string;
  tags?: string[];
  isSensitive?: boolean;
  publishLocation?: string;
  mentions?: ActivityMentionJSON[];
}

export class ActivityEnrichmentConfiguration {
  title: string;
  tags: string[];
  isSensitive: boolean;
  publishLocation: string;
  mentions: ActivityMention[];

  constructor(json: ActivityEnrichmentConfigurationJSON) {
    this.title = json.title || '';
    this.tags = json.tags || [];
    this.isSensitive = json.isSensitive || false;
    this.publishLocation = json.publishLocation || '';
    this.mentions = json.mentions ? json.mentions.map((m) => new ActivityMention(m)) : [];
  }
}
