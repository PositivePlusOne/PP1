export enum DataChangeType {
  None = 0,
  Create = 1 << 0,
  Update = 1 << 1,
  Delete = 1 << 2,
}

export function getDataChangeType (
  before: any,
  after: any
): DataChangeType {
  if (before && after) {
    return DataChangeType.Update;
  } else if (before) {
    return DataChangeType.Delete;
  } else if (after) {
    return DataChangeType.Create;
  } else {
    return DataChangeType.None;
  }
}

export function getDataChangeSchema (
  before: any,
  after: any
): string | null {
  if (before && after) {
    return before._fl_meta_.schema;
  } else if (before) {
    return before._fl_meta_.schema;
  } else if (after) {
    return after._fl_meta_.schema;
  } else {
    return null;
  }
}