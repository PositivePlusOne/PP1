import * as functions from "firebase-functions";

import { DataService } from "./data_service";
import { SystemService } from "./system_service";

import { POSITIVE_PLUS_ONE_ORGANISATION_ID } from "../constants/domain";

export namespace OrganisationService {
  /**
   * Creates a list of organisations.
   * @param {Organisation[]} organisations the organisations to create.
   * @return {Promise<void>} a promise that resolves when the organisations are created.
   */
  export async function createPositivePlusOneOrganisation(): Promise<void> {
    const organisation = {
      name: "Positive Plus One",
      description: "Positive Plus One is a social enterprise that aims to make the world a better place by inspiring people to be more positive and to help others.",
    };

    await createOrganisation(organisation, POSITIVE_PLUS_ONE_ORGANISATION_ID);
  }

  /**
   * Gets an organisation.
   * @param {string} organisationId the organisation id to get.
   * @return {Promise<any>} a promise that resolves with the organisation.
   */
  export async function getOrganisation(organisationId: string): Promise<any> {
    functions.logger.info("Getting organisation", organisationId);
    return await DataService.getDocument({
      schemaKey: "organisations",
      entryId: organisationId,
    });
  }

  /**
   * Creates an organisation.
   * @param {any} organisation the organisation to create.
   * @return {Promise<void>} a promise that resolves when the organisation is created.
   */
  export async function createOrganisation(organisation: any, id: string): Promise<void> {
    functions.logger.info("Creating organisation", organisation);
    const flamelinkApp = SystemService.getFlamelinkApp();
    await flamelinkApp.content.add({
      schemaKey: "organisations",
      entryId: id,
      data: organisation,
    });
  }

  /**
   * Updates an organisation.
   * @param {any} organisation the organisation to update.
   * @return {Promise<void>} a promise that resolves when the organisation is updated.
   */
  export async function updateOrganisation(organisation: any): Promise<void> {
    functions.logger.info("Updating organisation", organisation);
    await DataService.updateDocument({
      schemaKey: "organisations",
      entryId: organisation.foreignKey,
      data: organisation,
    });
  }

  /**
   * Deletes an organisation.
   * @param {string} organisationId the organisation id to delete.
   * @return {Promise<void>} a promise that resolves when the organisation is deleted.
   */
  export async function deleteOrganisation(
    organisationId: string
  ): Promise<void> {
    functions.logger.info("Deleting organisation", organisationId);
    await DataService.deleteDocument({
      schemaKey: "organisations",
      entryId: organisationId,
    });
  }

  /**
   * Checks if an organisation exists.
   * @param {string} organisationId the organisation id to check.
   * @return {Promise<boolean>} a promise that resolves to true if the organisation exists, otherwise false.
   */
  export async function checkOrganisationExists(
    organisationId: string
  ): Promise<boolean> {
    functions.logger.info("Checking organisation exists", organisationId);
    const organisation = await getOrganisation(organisationId);
    return organisation !== undefined;
  }
}
