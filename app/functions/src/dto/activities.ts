import { Timestamp } from "firebase-admin/firestore";
import { GeoLocation } from "./shared";

export enum ActivityActionVerb {
    Post = "post",
    Like = "like",
    Comment = "comment",
    Share = "share",
    Bookmark = "bookmark",
}

export type Activity = {
    foreignKey: string;
    generalConfiguration: ActivityGeneralConfiguration;
    securityConfiguration: ActivitySecurityConfiguration;
    eventConfiguration: ActivityEventConfiguration;
    pricingInformation: ActivityPricingInformation;
    publisherInformation: ActivityPublisherInformation;
    enrichmentConfiguration: ActivityEnrichmentConfiguration;
    media: MediaDto[];
}

export type ActivitySchedule = {
    startDate: Timestamp;
    endDate: Timestamp;
    reoccuranceRule: string;
}

export type ActivityMention = {
    startIndex: number;
    endIndex: number;
    organisation: string;
    user: string;
    activity: string;
    tag: string;
}

export type ActivityGeneralConfiguration = {
    type: ActivityGeneralConfigurationType;
    style: ActivityGeneralConfigurationStyle;
    content: string;
}

export enum ActivityGeneralConfigurationType {
    Post = "post",
    Event = "event",
    Clip = "clip",
}

export enum ActivityGeneralConfigurationStyle {
    Markdown = "markdown",
    Text = "text",
}

export type ActivitySecurityConfiguration = {
    context: string;
    visibilityMode: ActivitySecurityConfigurationMode;
    reactionMode: ActivitySecurityConfigurationMode;
    shareMode: ActivitySecurityConfigurationMode;
}

export enum ActivitySecurityConfigurationMode {
    Public = "public",
    FollowersAndConnections = "followers_and_connections",
    Connections = "connections",
    Private = "private",
}

export type ActivityEventConfiguration = {
    venue: string;
    name: string;
    schedule: ActivitySchedule;
    location: string;
    popularityScore: number;
    isCancelled: boolean;
}

export type ActivityPricingInformation = {
    productId: string;
    externalStoreInformation: ActivityPricingExternalStoreInformation;
}

export type ActivityPricingExternalStoreInformation = {
    costExact: string;
    costMinimum: string;
    costMaximum: string;
    pricingStrategy: ActivityPricingExternalStoreInformationPricingStrategy;
}

export enum ActivityPricingExternalStoreInformationPricingStrategy {
    OnePerson = "persons_1",
}

export type ActivityPublisherInformation = {
    foreignKey: string;
}

export type ActivityEnrichmentConfiguration = {
    title: string;
    tags: string[];
    isSensitive: boolean;
    publishLocation: GeoLocation | null;
    mentions: ActivityMention[];
}

export type MediaDto = {
    type: MediaType;
    url: string;
    priority: number;
}

export const MEDIA_PRIORITY_MAX = 0;
export const MEDIA_PRIORITY_DEFAULT = 1000;

export enum MediaType {
    WebsiteLink = "website_link",
    TicketLink = "ticket_link",
    VideoLink = "video_link",
    PhotoLink = "photo_link",
}