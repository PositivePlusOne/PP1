// import { applicationConfig } from "..";
import { Keys } from "./keys";

import * as functions from "firebase-functions";
import * as functions_v2 from "firebase-functions/v2";

export const FIREBASE_FUNCTION_INSTANCE_DATA = {
  secrets: Keys.AllKeys,
  timeoutSeconds: 60,
  vpcConnector: "redis-vpc-conn",
  minInstances: 1,
  memory: "128MB",
} as functions.RuntimeOptions;

export const FIREBASE_FUNCTION_INSTANCE_DATA_256 = {
  secrets: Keys.AllKeys,
  vpcConnector: "redis-vpc-conn",
  minInstances: 1,
  memory: "256MB",
} as functions.RuntimeOptions;

export const FIREBASE_FUNCTION_INSTANCE_DATA_ONE_INSTANCE = {
  secrets: Keys.AllKeys,
  timeoutSeconds: 60,
  vpcConnector: "redis-vpc-conn",
  minInstances: 1,
  maxInstances: 1,
  memory: "128MB",
} as functions.RuntimeOptions;

export const GENERIC_API_TIMEOUT = 10000;

// V2 global configuration
functions_v2.logger.info("Setting global options for v2 functions");
functions_v2.setGlobalOptions({
  memory: "128MiB",
  region: "us-central1",
  timeoutSeconds: 60,
  vpcConnector: "redis-vpc-conn",
  minInstances: 1,
  secrets: Keys.AllKeys,
});