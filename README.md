# Positive Plus One

Mono-repository for all things Positive Plus One.  
All documentation can be viewed [here.](https://inqvine.bit.ai/rdc/v0pZp5OR9DaNTn83)

## Running workflows locally

In order to test our Github workflows locally, we utilise the ACT cli tool.  
https://github.com/nektos/act  

You will need to install this for your relevant platform:

Windows: `choco install act-cli`
MacOS / Linux: `brew install act-cli`

## Running functions locally

Follow this article, using the service key from the developers.  
Note: You will need to uncomment a line in [ServiceInitialization] to bind to the emulator.  
`https://medium.com/firebase-developers/debugging-firebase-functions-in-vs-code-a1caf22db0b2`

# Google Cloud Overview

The project uses GCP to host all of its resources.
The plan is in the future to make this easy to deploy by using Terraform or ==.

List of services and use case:

* Firebase Functions: Serverless code execution used for our API
* Firebase Cloud Firestore: Database
* Firebase Crashlytics: Crash reporting for in app
* Firebase App Distribution: Internal build distribution
* Google Serverless VPC Connection: Used for connecting internal Cloud Functions to other Google resources, such as redis
* Google Memorystore Redis: Shared cache between all Cloud Functions
* Google Secrets Manager: Key/Value secrets
* Check the full API library at GCP for any missed

IAM roles and access as granted on a per request basis, and are handled manually for now.  
Some usual roles to ensure you have as a developer are: 

* Cloud Functions Invoker
* Secrets Manager Admin

You may need to also grant higher access to users for Firebase resources, however this is done via the UI.  
Note: A known bug may cause new users to not be able to deploy functions first time, you will need further roles on IAM to cover this.

## Deploying a new environment

TBC

## FAQS and Debugging

### Using build runner watch
A tonne of code will be auto generated while you develop on this app.  
You can setup the listener by running the following command:
`flutter pub run build_runner watch --delete-conflicting-outputs`

### I cannot attch my node debugger to Firebase Functions
There is a known bug for this here: `https://github.com/firebase/firebase-tools/issues/4166`.  
You can fix it by downgrading `firebase-tools`.  

### How do I run the import sorter?
`fvm flutter pub run import_sorter:main`

### How do I change the phone number and verification code for the Firebase Auth emulator
Look in the terminal when you make the verification request.

### Quick gotchas

q) I am getting Quota Exceeded when updating functions
a) This quota is only for updating, therefore you can either update specific functions by using the `firebase deploy --only functions:relationships-connectRelationship` syntax, or you can delete them and add to bypass it entirely.

q) [firebase_functions/internal] INTERNAL: Could not fetch secret "projects/**/secrets/**" for environment variable "**_API_KEY".
a) Redeploy firebase functions to rebuild permissions/secrets 

q) Redis is failing to be contacted
a) Verify your Serverless VPC connector is attached to the same subnet, and that the Cloud Functions Service IAM account has the following roles:  
* Compute Network User
* Serverless VPC Access User