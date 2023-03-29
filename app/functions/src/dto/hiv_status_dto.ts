export type HivStatusDto = {
  value: string;
  label: string;
  children?: HivStatusDto[];
};
