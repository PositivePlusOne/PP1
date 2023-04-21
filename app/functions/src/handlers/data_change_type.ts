export enum DataChangeType {
  None = 0,
  Create = 1 << 0,
  Update = 1 << 1,
  Delete = 1 << 2,
}
