// import { applicationConfig } from "..";
import { Keys } from "./keys";

import * as functions from "firebase-functions";

export const FIREBASE_FUNCTION_INSTANCE_DATA = {
  secrets: Keys.AllKeys,
  vpcConnector: "redis-vpc-conn",
  minInstances: 1,
  memory: "128MB",
  timeoutSeconds: 540,
} as functions.RuntimeOptions;

export const FIREBASE_FUNCTION_INSTANCE_DATA_256 = {
  secrets: Keys.AllKeys,
  vpcConnector: "redis-vpc-conn",
  minInstances: 1,
  memory: "256MB",
  timeoutSeconds: 540,
} as functions.RuntimeOptions;

export const FIREBASE_FUNCTION_INSTANCE_DATA_1G = {
  secrets: Keys.AllKeys,
  vpcConnector: "redis-vpc-conn",
  minInstances: 1,
  memory: "1GB",
  timeoutSeconds: 540,
} as functions.RuntimeOptions;

export const FIREBASE_FUNCTION_INSTANCE_DATA_ONE_INSTANCE = {
  secrets: Keys.AllKeys,
  vpcConnector: "redis-vpc-conn",
  minInstances: 1,
  maxInstances: 1,
  memory: "128MB",
  timeoutSeconds: 540,
} as functions.RuntimeOptions;

export const GENERIC_API_TIMEOUT = 10000;