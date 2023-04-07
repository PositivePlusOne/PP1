export enum EntityRelationship {
  None = 0,
  Anonymous = 1 << 0,
  Connected = 1 << 1,
  Following = 1 << 2,
  Owner = 1 << 3,
  Admin = 1 << 4,
}

export const EntityRelationshipDeterministic =
  EntityRelationship.Owner |
  EntityRelationship.Admin |
  EntityRelationship.Connected |
  EntityRelationship.Following |
  EntityRelationship.Anonymous;

export const EntityRelationshipPrivate =
  EntityRelationship.Owner | EntityRelationship.Admin;
