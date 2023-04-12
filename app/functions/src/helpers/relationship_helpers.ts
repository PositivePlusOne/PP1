export namespace RelationshipHelpers {
  /**
   * Checks if a relationship can be acted upon by the given user.
   * @param {string} uid the user id.
   * @param {any} relationship the relationship to check.
   * @return {boolean} true if the relationship can be acted upon, false otherwise.
   */
  export function canActionRelationship(
    uid: string,
    relationship: any
  ): boolean {
    if (!relationship) {
      return false;
    }
    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === uid) {
          continue;
        }
        if (member.hasBlocked) {
          return false;
        }
      }
    }
    return true;
  }

  /**
   * Gets a list of user ids that should be notified of a relationship connection request.
   * @param {string} uid the user id.
   * @param {any} relationship the relationship to check.
   * @return {string[]} the list of user ids to notify.
   */
  export function getRequestConnectionNotificationTargets(
    uid: string,
    relationship: any
  ): string[] {
    const targets: string[] = [];
    if (!relationship) {
      return targets;
    }

    if (hasOtherUserBlocked(uid, relationship)) {
      return targets;
    }

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === uid) {
          continue;
        }

        if (!member.hasConnected) {
          targets.push(member.memberId);
        }
      }
    }

    return targets;
  }

  /**
   * Gets a list of user ids that should be notified of a relationship connection acceptance.
   * @param {string} uid the user id.
   * @param {any} relationship the relationship to check.
   * @return {string[]} the list of user ids to notify.
   */
  export function getConnectionAcceptedNotificationTargets(
    uid: string,
    relationship: any
  ): string[] {
    const targets: string[] = [];
    if (!relationship) {
      return targets;
    }

    if (hasOtherUserBlocked(uid, relationship)) {
      return targets;
    }

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === uid) {
          continue;
        }

        if (member.hasConnected) {
          targets.push(member.memberId);
        }
      }
    }

    return targets;
  }

  /**
   * Checks if the given user is connected to the relationship.
   * @param {string} uid the user id.
   * @param {any} relationship the relationship to check.
   * @return {boolean} true if the user is connected, false otherwise.
   */
  export function isUserConnected(uid: string, relationship: any): boolean {
    if (!relationship) {
      return false;
    }

    if (hasOtherUserBlocked(uid, relationship)) {
      return false;
    }

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (
          typeof member.memberId === "string" &&
          member.memberId === uid &&
          member.hasConnected
        ) {
          return true;
        }
      }
    }

    return false;
  }

  /**
   * Checks if another user has blocked the relationship.
   * @param {string} uid the user id.
   * @param {any} relationship the relationship to check.
   * @return {boolean} true if another user has blocked the relationship, false otherwise.
   */
  export function hasOtherUserBlocked(uid: string, relationship: any): boolean {
    if (!relationship) {
      return false;
    }

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (
          typeof member.memberId === "string" &&
          member.memberId !== uid &&
          member.hasBlocked
        ) {
          return true;
        }
      }
    }

    return false;
  }

  /**
   * Checks if the given user has blocked the relationship.
   * @param {string} uid the user id.
   * @param {any} relationship the relationship to check.
   * @return {boolean} true if the user has blocked the relationship, false otherwise.
   */
  export function hasUserBlocked(uid: string, relationship: any): boolean {
    if (!relationship) {
      return false;
    }

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (
          typeof member.memberId === "string" &&
          member.memberId === uid &&
          member.hasBlocked
        ) {
          return true;
        }
      }
    }

    return false;
  }
}
