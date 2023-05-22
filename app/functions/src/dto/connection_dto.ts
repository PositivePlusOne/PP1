import { GeoPoint } from "firebase-admin/firestore";

export type ConnectedUserDto = {
  id: string;
  displayName: string;
  profileImage?: string;
  accentColor?: string;
  location?: GeoPoint | null;
  hivStatus?: string;
  interests?: string[];
  genders?: string[];
  birthday?: string;
};
