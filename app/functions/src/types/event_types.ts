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
  rrule: string;
  source_url: string;
  image_url: string;
  image_url_2: string;
  image_url_3: string;
  image_url_4: string;
  image_url_5: string;
  ticket_url: string;
  stated_covid_precautions: string;
  virtual_address: string;
  virtual_rule: string;
  popularity_score: number;
  annual: boolean;
  cancelled: any[];
  minimum_price: string;
  maximum_price: string;
}

export interface Venue {
  uuid: string;
  name: string;
  address_1: string;
  address_2: string;
  city: string;
  region: string;
  country: string;
  postal_code: string;
  space: string;
  latitude: string;
  longitude: string;
}
