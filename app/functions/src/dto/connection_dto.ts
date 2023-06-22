export type ConnectedUserDto = {
  id: string;
  displayName: string;
  profileImage?: string;
  accentColor?: string;
  hivStatus?: string;
  interests?: string[];
  genders?: string[];
  birthday?: string;
  place?: {
    description: string;
    latitude: number;
    longitude: number;
    optOut: boolean;
    placeId: string;
  };
};
