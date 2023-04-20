import * as functions from "firebase-functions";

import { DataChangeType } from "./data_change_type";

interface RegisteredChangeHandler {
  changeType: DataChangeType;
  schema: string;
  id: string;
  func: (changeType: DataChangeType, schema: string, id: string, before: any, after: any) => Promise<void>;
}

export namespace DataHandlerRegistry {
  const registeredChangeHandlers: RegisteredChangeHandler[] = [];

  /**
   * Registers a change handler.
   * @param {DataChangeType} changeType the change type.
   * @param {string} schema the schema.
   * @param {string} id the id.
   * @param {any} before the before data.
   * @param {any} after the after data.
   * @param {() => void} func the function to call.
   */
  export function registerChangeHandler(
    changeType: DataChangeType,
    schema: string,
    id: string,
    func: (changeType: DataChangeType, schema: string, id: string, before: any, after: any) => Promise<void>
  ): void {
    functions.logger.info("Registering change handler", {
      changeType,
      schema,
      id,
    });

    registeredChangeHandlers.push({
      changeType,
      schema,
      id,
      func,
    });
  }

  /**
   * Executes the change handlers for a given change type and schema.
   * @param {DataChangeType} changeType the change type.
   * @param {string} schema the schema.
   * @param {string} id the id.
   */
  export async function executeChangeHandlers(
    changeType: DataChangeType,
    schema: string,
    id: string,
    before: any,
    after: any
  ): Promise<void> {
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
   * Gets the change handlers for a given change type and schema.
   * @param {DataChangeType} changeType the change type.
   * @param {string} schema the schema.
   * @param {string} id the id.
   * @return {RegisteredChangeHandler[]} the change handlers.
   */
  export function getChangeHandlers(
    changeType: DataChangeType,
    schema: string,
    id: string
  ): RegisteredChangeHandler[] {
    functions.logger.info("Getting change handlers", {
      changeType,
      schema,
      id,
    });

    const changeHandlers = registeredChangeHandlers.filter(
      (changeHandler) =>
        (changeHandler.changeType & changeType) === changeType &&
        (changeHandler.schema === schema || changeHandler.schema === "*") &&
        (changeHandler.id === id || changeHandler.id === "*")
    );

    functions.logger.info("Change handlers", {
      changeType,
      schema,
      id,
      count: changeHandlers.length,
    });

    return changeHandlers;
  }
}
