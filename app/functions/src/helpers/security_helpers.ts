import { ActivityJSON, ActivitySecurityConfigurationMode } from '../dto/activities';
import { RelationshipJSON } from '../dto/relationships';
import { RelationshipHelpers } from './relationship_helpers';

export namespace SecurityHelpers {
    export function canActOnActivity(
        activity: ActivityJSON,
        relationship: RelationshipJSON,
        userId: string,
        mode: ActivitySecurityConfigurationMode,
    ): boolean {
        const publisherProfileId = activity?.publisherInformation?.publisherId || '';
        if (userId && userId === publisherProfileId) {
            return true;
        }
        
        if (!activity || !mode || !userId || !publisherProfileId) {
            return false;
        }

        switch (mode) {
            case "disabled":
                return false;
            case "private":
                return publisherProfileId === userId;
            case "public":
                return true;
            case "signed_in":
                return userId !== '';
            case "connections":
                return RelationshipHelpers.isUserConnected(userId, relationship);
            case "followers_and_connections":
                return RelationshipHelpers.isUserConnected(userId, relationship) || RelationshipHelpers.isUserFollowing(userId, relationship);
            default:
                return false;
        }
    }
}