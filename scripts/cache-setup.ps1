# enable APIs
gcloud services enable redis.googleapis.com
gcloud services enable cloudfunctions.googleapis.com
gcloud services enable vpcaccess.googleapis.com
gcloud services enable secretmanager.googleapis.com

# set these to your specific environment
$env:PROJECT_ID="positiveplusone-staging"
$env:REDIS_INSTANCE="redis-firestore-cache"
$env:REDIS_VERSION="redis_4_0"
$env:GCP_REGION="us-central1"
$env:GCP_NETWORK="default"
$env:VPC_CONNECTOR="redis-vpc-conn"
$env:VPC_RANGE="10.8.0.0/28"
$env:STORAGE_ROLE="storageRoleStaging"

# fetch the project number to use in IAM bindings
$env:PROJECT_NUM=$(gcloud projects describe $env:PROJECT_ID --format="value(projectNumber)")
Write-Output "Project number: $env:PROJECT_NUM"

# create redis cluster
gcloud redis instances create $env:REDIS_INSTANCE --size=1 --region=$env:GCP_REGION --redis-version=$env:REDIS_VERSION

# confirm redis installation
gcloud redis instances describe $env:REDIS_INSTANCE --region=$env:GCP_REGION

# fetch the authorizedNetwork (if not 'default' then change vars above)
$env:REDIS_NETWORK=$(gcloud redis instances describe $env:REDIS_INSTANCE --region=$env:GCP_REGION --format="value(authorizedNetwork)")
$env:REDIS_HOST=$(gcloud redis instances describe $env:REDIS_INSTANCE --region=$env:GCP_REGION --format="value(host)")
$env:REDIS_PORT=$(gcloud redis instances describe $env:REDIS_INSTANCE --region=$env:GCP_REGION --format="value(port)")
Write-Output "Redis network: $env:REDIS_NETWORK, host: $env:REDIS_HOST, port: $env:REDIS_PORT"

# create VPC connector (use the network name [not full path] and region from above)
gcloud compute networks vpc-access connectors create $env:VPC_CONNECTOR --network $env:GCP_NETWORK --region=$env:GCP_REGION --range=$env:VPC_RANGE

# verify connector
gcloud compute networks vpc-access connectors describe $env:VPC_CONNECTOR --region=$env:GCP_REGION

# create custom role for storage permissions
gcloud iam roles create $env:STORAGE_ROLE --project $env:PROJECT_ID --title $env:STORAGE_ROLE --description "get and create storage objects" --permissions "storage.objects.create,storage.objects.get"

$env:STORAGE_ROLE_NAME=$(gcloud iam roles describe $env:STORAGE_ROLE --project $env:PROJECT_ID --format="value(name)")
Write-Output "Storage role: $env:STORAGE_ROLE_NAME"

# add IAM bindings (replace project number with one you fetched)
gcloud projects add-iam-policy-binding $env:PROJECT_ID --member=serviceAccount:service-$env:PROJECT_NUM@gcf-admin-robot.iam.gserviceaccount.com --role=roles/viewer
gcloud projects add-iam-policy-binding $env:PROJECT_ID --member=serviceAccount:service-$env:PROJECT_NUM@gcf-admin-robot.iam.gserviceaccount.com --role=roles/compute.networkUser
gcloud projects add-iam-policy-binding $env:PROJECT_ID --member=serviceAccount:service-$env:PROJECT_NUM@gcf-admin-robot.iam.gserviceaccount.com --role=$env:STORAGE_ROLE_NAME

# Create secrets
firebase functions:config:set config.redis_host="$env:REDIS_HOST" config.redis_port="$env:REDIS_PORT" config.vpc_connector="projects/$env:PROJECT_ID/locations/$env:GCP_REGION/connectors/$env:VPC_CONNECTOR"
