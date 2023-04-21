import { Timestamp } from "firebase-admin/firestore";
import { GeoLocation } from "./shared";

export type ActivityDto = {
    generalConfiguration: ActivityGeneralConfiguration;
    securityConfiguration: ActivitySecurityConfiguration;
    eventConfiguration: ActivityEventConfiguration;
    pricingInformation: ActivityPricingInformation;
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
    visibilityMode: ActivitySecurityConfigurationVisibilityMode;
    reactionMode: ActivitySecurityConfigurationReactionMode;
}

export enum ActivitySecurityConfigurationVisibilityMode {
    Public = "public",
    FollowersAndConnections = "followers_and_connections",
    Connections = "connections",
    Private = "private",
}

export enum ActivitySecurityConfigurationReactionMode {
    Disabled = "disabled",
    Public = "public",
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

export type ActivityEnrichmentConfiguration = {
    tags: string[];
    isSensitive: boolean;
    location: GeoLocation;
    mentions: ActivityMention[];
}

export type MediaDto = {
    type: MediaType;
    url: string;
    priority: number;
}

export enum MediaType {
    WebsiteLink = "website_link",
    TicketLink = "ticket_link",
    VideoLink = "video_link",
    PhotoLink = "photo_link",
}