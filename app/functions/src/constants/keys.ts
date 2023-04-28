export namespace Keys {
    export const PositivePlusOneFunctionKey = "POSITIVEPLUSONE_FUNCTION_KEY";
    export const PositivePlusOneProfileKey = "POSITIVEPLUSONE_PROFILE_KEY";
    export const OccasionGeniusApiKey = "OCCASION_GENIUS_API_KEY";
    export const StreamApiKey = "STREAM_API_KEY";
    export const StreamFeedsApiKey = "STREAM_FEEDS_API_KEY";
    export const StreamApiSecret = "STREAM_API_SECRET";
    export const StreamFeedsApiSecret = "STREAM_FEEDS_API_SECRET";
    export const MeiliSearchHostUrl = "MEILISEARCH_HOST_URL";
    export const MeiliSearchApiKey = "MEILISEARCH_API_KEY";
    export const GoogleMapKey = "MAPS_API_KEY";

    //* Feature flags
    export const FeatureFlagManagedOrganisation = "MANAGED_ORGANISATION";

    // A map of all the keys
    export const AllKeys = [
        OccasionGeniusApiKey,
        StreamApiKey,
        StreamFeedsApiKey,
        StreamApiSecret,
        StreamFeedsApiSecret,
        MeiliSearchHostUrl,
        MeiliSearchApiKey,
        GoogleMapKey,
        PositivePlusOneProfileKey,
        PositivePlusOneFunctionKey,
    ];

    export const AlgoliaIndex = "_fl_meta_.fl_id";
}