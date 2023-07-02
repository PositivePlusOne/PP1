// import { applicationConfig } from "..";
import { Keys } from "./keys";

import * as functions from "firebase-functions";

export const FIREBASE_FUNCTION_INSTANCE_DATA = {
  secrets: Keys.AllKeys,
  timeoutSeconds: 60,
  vpcConnector: "redis-vpc-conn",
  maxInstances: 1,
  memory: "128MB",
} as functions.RuntimeOptions;
