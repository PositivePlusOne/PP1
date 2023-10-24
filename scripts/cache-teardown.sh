#!/usr/bin/env bash

# set these to your specific environment
export PROJECT_ID=positiveplusone-develop
export REDIS_INSTANCE=redis-firestore-cache
export GCP_REGION=europe-west3
export VPC_CONNECTOR=redis-vpc-conn
export STORAGE_ROLE=simpleStorageRole

# delete secrets
gcloud secrets delete REDIS_HOST --project $PROJECT_ID
gcloud secrets delete REDIS_PORT --project $PROJECT_ID
gcloud secrets delete VPC_CONNECTOR_NAME --project $PROJECT_ID

# remove IAM bindings
export PROJECT_NUM=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
gcloud projects remove-iam-policy-binding $PROJECT_ID --member=serviceAccount:service-$PROJECT_NUM@gcf-admin-robot.iam.gserviceaccount.com --role=roles/viewer
gcloud projects remove-iam-policy-binding $PROJECT_ID --member=serviceAccount:service-$PROJECT_NUM@gcf-admin-robot.iam.gserviceaccount.com --role=roles/compute.networkUser
gcloud projects remove-iam-policy-binding $PROJECT_ID --member=serviceAccount:service-$PROJECT_NUM@gcf-admin-robot.iam.gserviceaccount.com --role=roles/$STORAGE_ROLE

# delete custom role
gcloud iam roles delete $STORAGE_ROLE --project $PROJECT_ID

# delete VPC connector
gcloud compute networks vpc-access connectors delete $VPC_CONNECTOR --region $GCP_REGION

# delete Redis instance
gcloud redis instances delete $REDIS_INSTANCE --region=$GCP_REGION
