#!/usr/bin/env bash

# Reference: https://cloud.google.com/memorystore/docs/redis/connect-redis-instance-functions#python

# enable APIs
gcloud services enable redis.googleapis.com
gcloud services enable cloudfunctions.googleapis.com
gcloud services enable vpcaccess.googleapis.com

# set these to your specific environment
export PROJECT_ID=positiveplusone-develop
export REDIS_INSTANCE=redis-firestore-cache
export REDIS_VERSION="redis_4_0"
export GCP_REGION=us-central1
export GCP_NETWORK=default
export VPC_CONNECTOR=redis-vpc-conn
export VPC_RANGE="10.8.0.0/28"
export STORAGE_ROLE=simpleStorageRole

# create redis cluster
gcloud redis instances create $REDIS_INSTANCE --size=1 --region=$GCP_REGION \
    --redis-version=$REDIS_VERSION

# confirm redis installation
gcloud redis instances describe $REDIS_INSTANCE --region=$GCP_REGION

# fetch the authorizedNetwork (if not 'default' then change vars above)
export REDIS_NETWORK=$(gcloud redis instances describe $REDIS_INSTANCE --region=$GCP_REGION --format="value(authorizedNetwork)")
export REDIS_HOST=$(gcloud redis instances describe $REDIS_INSTANCE --region=$GCP_REGION --format="value(host)")
export REDIS_PORT=$(gcloud redis instances describe $REDIS_INSTANCE --region=$GCP_REGION --format="value(port)")
echo "Redis network: $REDIS_NETWORK, host: $REDIS_HOST, port: $REDIS_PORT"

# create VPC connector (use the network name [not full path] and region from above)
gcloud compute networks vpc-access connectors create $VPC_CONNECTOR \
    --network $GCP_NETWORK \
    --region $GCP_REGION \
    --range $VPC_RANGE

# verify connector
gcloud compute networks vpc-access connectors describe $VPC_CONNECTOR --region $GCP_REGION

# fetch the project number to use in IAM bindings
export PROJECT_NUM=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
echo "Project number: $PROJECT_NUM"

# create custom role for storage permissions
gcloud iam roles create $STORAGE_ROLE \
    --project $PROJECT_ID \
    --title $STORAGE_ROLE \
    --description "get and create storage objects" \
    --permissions "storage.objects.create,storage.objects.get"

export STORAGE_ROLE_NAME=$(gcloud iam roles describe $STORAGE_ROLE --project $PROJECT_ID --format="value(name)")
echo "Storage role: $STORAGE_ROLE_NAME"

# add IAM bindings (replace project number with one you fetched)
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:service-$PROJECT_NUM@gcf-admin-robot.iam.gserviceaccount.com \
    --role=roles/viewer

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:service-$PROJECT_NUM@gcf-admin-robot.iam.gserviceaccount.com \
    --role=roles/compute.networkUser

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:service-$PROJECT_NUM@gcf-admin-robot.iam.gserviceaccount.com \
    --role=roles/secretmanager.versions.access

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:service-$PROJECT_NUM@gcf-admin-robot.iam.gserviceaccount.com \
    --role=$STORAGE_ROLE_NAME

# add secrets
gcloud secrets create REDIS_HOST --replication-policy=automatic --data-file=<(echo -n $REDIS_HOST) --project $PROJECT_ID
gcloud secrets create REDIS_PORT --replication-policy=automatic --data-file=<(echo -n $REDIS_PORT) --project $PROJECT_ID
gcloud secrets create VPC_CONNECTOR_NAME --replication-policy=automatic --data-file=<(echo -n "projects/$PROJECT_ID/locations/$GCP_REGION/connectors/$VPC_CONNECTOR") --project $PROJECT_ID
