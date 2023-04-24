import { Keys } from "./keys";

import * as functions from "firebase-functions";

export const POSITIVE_PLUS_ONE_ORGANISATION_ID = "42HG-T4RD-1S5C-RWHR-H0BB";

export const FIREBASE_FUNCTION_INSTANCE_DATA = {
  secrets: Keys.AllKeys,
  timeoutSeconds: 60,
} as functions.RuntimeOptions;
