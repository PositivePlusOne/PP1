export type RelationshipFlags = {
  blocked: boolean;
  muted: boolean;
  hidden: boolean;
  connected: boolean;
  followed: boolean;
};

export const defaultRelationshipFlags: RelationshipFlags = {
  blocked: false,
  muted: false,
  hidden: false,
  connected: false,
  followed: false,
};
