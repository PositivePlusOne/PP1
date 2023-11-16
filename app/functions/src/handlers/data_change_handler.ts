import * as functions from "firebase-functions";

import { DataChangeType } from "./data_change_type";

export interface RegisteredChangeHandler {
  changeType: DataChangeType;
  schemas: string[];
  id: string;
  func: (changeType: DataChangeType, schema: string, id: string, before: any, after: any) => Promise<void>;
}

export namespace DataHandlerRegistry {
  const registeredChangeHandlers: RegisteredChangeHandler[] = [];

  /**
   * Registers a change handler.
   * @param {DataChangeType} changeType the change type.
   * @param {string[]} schemas the schemas.
   * @param {string} id the id.
   * @param {(changeType: DataChangeType, schema: string, id: string, before: any, after: any) => Promise<void>} func the function to execute.
   */
  export function registerChangeHandler(changeType: DataChangeType, schemas: string[], id: string, func: (changeType: DataChangeType, schema: string, id: string, before: any, after: any) => Promise<void>): void {
    functions.logger.info("Registering change handler", {
      changeType,
      schemas,
      id,
    });

    registeredChangeHandlers.push({
      changeType,
      schemas,
      id,
      func,
    });
  }

  /**
   * Executes the change handlers.
   * @param {DataChangeType} changeType the change type.
   * @param {string} schema the schema.
   * @param {string} id the id.
   * @param {any} before the before data.
   * @param {any} after the after data.
   * @return {Promise<void>} a promise that resolves when the change handlers have been executed.
   */
  export async function executeChangeHandlers(changeType: DataChangeType, schema: string, id: string, before: any, after: any): Promise<void> {
    functions.logger.info("Executing change handlers", {
      changeType,
      schema,
      id,
    });

    const changeHandlers = getChangeHandlers(changeType, schema, id);
    for (const changeHandler of changeHandlers) {
      functions.logger.info("Executing change handler", {
        changeType,
        schema,
        id,
      });

      await changeHandler.func(changeType, schema, id, before, after);
    }
  }

  /**
   * Gets the change handlers.
   * @param {DataChangeType} changeType the change type.
   * @param {string} schema the schema.
   * @param {string} id the id.
   * @return {RegisteredChangeHandler[]} the change handlers.
   */
  export function getChangeHandlers(changeType: DataChangeType, schema: string, id: string): RegisteredChangeHandler[] {
    functions.logger.info("Getting change handlers", {
      changeType,
      schema,
      id,
    });

    const changeHandlers = registeredChangeHandlers.filter((changeHandler) => {
      const changeTypeMatch = (changeHandler.changeType & changeType) !== 0;
      const schemaMatch = changeHandler.schemas.includes("*") || changeHandler.schemas.includes(schema);
      const idMatch = changeHandler.id === "*" || changeHandler.id === id;

      return changeTypeMatch && schemaMatch && idMatch;
    });

    functions.logger.info("Change handlers", {
      changeType,
      schema,
      id,
      count: changeHandlers.length,
    });

    return changeHandlers;
  }
}
