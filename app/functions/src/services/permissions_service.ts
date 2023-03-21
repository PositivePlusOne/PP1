import * as functions from "firebase-functions";
import { EntityRelationship } from "./enumerations/entity_relationship";

import { AuthorizationTarget } from "./enumerations/authorization_target";
import { PermissionLevel } from "./enumerations/permission_level";

export namespace PermissionsService {
  /**
   * Checks if the user has the required permission level.
   * @param {functions.https.CallableContext} context The context of the callable function.
   * @param {AuthorizationTarget} target The target of the authorization.
   * @param {string} entityId The ID of the entity to authorize.
   * @return {boolean} if the user has the required permission level, false otherwise.
   */
  export function hasPermission(
    context: functions.https.CallableContext,
    target: AuthorizationTarget,
    entityId: string
  ): boolean {
    switch (target) {
      case AuthorizationTarget.Profile:
        return hasProfilePermission(context, entityId);
      default:
        return false;
    }
  }

  /**
   * Checks if the user has the required permission level.
   * @param {functions.https.CallableContext} context The context of the callable function.
   * @param {string} _entityId The ID of the entity to authorize.
   * @return {boolean} if the user has the required permission level, false otherwise.
   */
  export function hasProfilePermission(
    context: functions.https.CallableContext,
    _entityId: string
  ): boolean {
    const uid = context.auth?.uid || "";
    return uid.length > 0;
  }

  /**
   * Gets the permission level of the user for the target.
   * @param {functions.https.CallableContext} context The context of the callable function.
   * @param {AuthorizationTarget} target The target of the authorization.
   * @param {string} entityId The ID of the entity to authorize.
   * @return {PermissionLevel} The permission level of the user for the target.
   */
  export function getPermissionLevel(
    context: functions.https.CallableContext,
    target: AuthorizationTarget,
    entityId: string
  ): PermissionLevel {
    switch (target) {
      case AuthorizationTarget.Profile:
        return getProfilePermissionLevel(context, entityId);
      default:
        return PermissionLevel.None;
    }
  }

  /**
   * Gets the permission level of the user for the profile.
   * @param {functions.https.CallableContext} context The context of the callable function.
   * @param {string} entityId The ID of the entity to authorize.
   * @return {PermissionLevel} The permission level of the user for the profile.
   */
  export function getProfilePermissionLevel(
    context: functions.https.CallableContext,
    entityId: string
  ): PermissionLevel {
    const uid = context.auth?.uid || "";
    if (uid === entityId) {
      return (
        PermissionLevel.Delete | PermissionLevel.Read | PermissionLevel.Write
      );
    }

    return PermissionLevel.Read;
  }

  /**
   * Gets the relationship between the user and the target.
   * @param {functions.https.CallableContext} context The context of the callable function.
   * @param {AuthorizationTarget} target The target of the authorization.
   * @param {string} entityId The ID of the entity to authorize.
   * @return {EntityRelationship} The relationship between the user and the target.
   */
  export function getEntityRelationship(
    context: functions.https.CallableContext,
    target: AuthorizationTarget,
    entityId: string
  ): EntityRelationship {
    switch (target) {
      case AuthorizationTarget.Profile:
        return getProfileAuthorizationLevel(context, entityId);
      default:
        return EntityRelationship.Anonymous;
    }
  }

  /**
   * Gets the entity relationship between the user and the profile.
   * @param {functions.https.CallableContext} context The context of the callable function.
   * @param {string} entityId The ID of the entity to authorize.
   * @return {EntityRelationship} The entity relationship between the user and the profile.
   */
  export function getProfileAuthorizationLevel(
    context: functions.https.CallableContext,
    entityId: string
  ): EntityRelationship {
    const uid = context.auth?.uid || "";
    if (uid === entityId) {
      return EntityRelationship.Owner;
    }

    // TODO: Check if the user is following or connected to the profile.

    return EntityRelationship.Anonymous;
  }
}
