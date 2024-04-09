export interface EnforcedPlaceJSON {
  uniqueKey?: string;
  enforcementType?: string;
  enforcementMatcher?: string;
  enforcementValue?: string;
}

export class EnforcedPlace {
  uniqueKey?: string;
  enforcementType?: string;
  enforcementMatcher?: string;
  enforcementValue?: string;

  constructor(json: EnforcedPlaceJSON) {
    this.uniqueKey = json.uniqueKey;
    this.enforcementType = json.enforcementType;
    this.enforcementMatcher = json.enforcementMatcher;
    this.enforcementValue = json.enforcementValue;
  }

  toJSON(): EnforcedPlaceJSON {
    return {
      uniqueKey: this.uniqueKey,
      enforcementType: this.enforcementType,
      enforcementMatcher: this.enforcementMatcher,
      enforcementValue: this.enforcementValue,
    };
  }
}
