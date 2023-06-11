# set these to your specific environment
$env:PROJECT_ID="positiveplusone-develop"
$env:REDIS_INSTANCE="redis-firestore-cache"
$env:GCP_REGION="us-central1"
$env:VPC_CONNECTOR="redis-vpc-conn"
$env:STORAGE_ROLE="simpleStorageRole"

# delete secrets
gcloud secrets delete REDIS_HOST --project $env:PROJECT_ID
gcloud secrets delete REDIS_PORT --project $env:PROJECT_ID
gcloud secrets delete VPC_CONNECTOR_NAME --project $env:PROJECT_ID

# remove IAM bindings
$env:PROJECT_NUM=$(gcloud projects describe $env:PROJECT_ID --format="value(projectNumber)")
gcloud projects remove-iam-policy-binding $env:PROJECT_ID --member=serviceAccount:service-$env:PROJECT_NUM@gcf-admin-robot.iam.gserviceaccount.com --role=roles/viewer
gcloud projects remove-iam-policy-binding $env:PROJECT_ID --member=serviceAccount:service-$env:PROJECT_NUM@gcf-admin-robot.iam.gserviceaccount.com --role=roles/compute.networkUser
gcloud projects remove-iam-policy-binding $env:PROJECT_ID --member=serviceAccount:service-$env:PROJECT_NUM@gcf-admin-robot.iam.gserviceaccount.com --role=roles/$env:STORAGE_ROLE

# delete custom role
gcloud iam roles delete $env:STORAGE_ROLE --project $env:PROJECT_ID

# delete VPC connector
gcloud compute networks vpc-access connectors delete $env:VPC_CONNECTOR --region $env:GCP_REGION

# delete Redis instance
gcloud redis instances delete $env:REDIS_INSTANCE --region=$env:GCP_REGION
