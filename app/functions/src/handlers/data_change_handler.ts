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

  export function registerChangeHandler(
    changeType: DataChangeType,
    schemas: string[],
    id: string,
    func: (changeType: DataChangeType, schema: string, id: string, before: any, after: any) => Promise<void>
  ): void {
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

    const changeHandlers = registeredChangeHandlers.filter((changeHandler) => {
      const changeTypeMatch = (changeHandler.changeType & changeType) !== 0;
      const schemaMatch = changeHandler.schemas.includes('*') || changeHandler.schemas.includes(schema);
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
