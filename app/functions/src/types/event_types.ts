export interface ListEventResponse {
  count: number;
  next: string;
  previous: null;
  results: EventResult[];
}

export interface EventResult {
  uuid: string;
  recurring_event_uuid: string;
  umbrella_event_uuid: string;
  name: string;
  event_name_native: string;
  description: string;
  event_description_native: string;
  venue: Venue;
  flags: string[];
  start_date: Date;
  end_date: Date;
  instance_date: null | string;
  event_dates: Date[];
  rrule: Rrule;
  source_url: string;
  image_url: string;
  image_url_2: string;
  image_url_3: string;
  image_url_4: string;
  image_url_5: string;
  ticket_url: string;
  stated_covid_precautions: StatedCovidPrecautions;
  virtual_address: string;
  virtual_rule: VirtualRule;
  popularity_score: number;
  annual: boolean;
  cancelled: any[];
  minimum_price: string;
  maximum_price: string;
}

export enum Rrule {
  Empty = "",
  RruleInterval1FreqMonthly = "RRULE:INTERVAL=1;FREQ=MONTHLY",
  RruleInterval1FreqYearly = "RRULE:INTERVAL=1;FREQ=YEARLY",
}

export enum StatedCovidPrecautions {
  Empty = "",
  InPersonNotStated = "In-Person - Not Stated",
}

export interface Venue {
  uuid: string;
  name: string;
  address_1: string;
  address_2: string;
  city: string;
  region: string;
  country: Country;
  postal_code: string;
  space: string;
  latitude: string;
  longitude: string;
}

export enum Country {
  UnitedKingdomOfGreatBritainAndNorthernIreland = "United Kingdom of Great Britain and Northern Ireland",
  UnitedStatesOfAmerica = "United States of America",
}

export enum VirtualRule {
  NotVirtual = "Not Virtual",
}
