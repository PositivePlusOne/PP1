# Setting Up Your Development Environment: A Step-By-Step Guide

This guide aims to assist you in setting up the development environment for your programming project.

## Firebase Configuration

1. **Start the Project**: Initiate by creating a new application on Firebase.
2. **Link the Project**: Link your new project to this application. Ensure the following:

    - The `.firebaserc` file is properly configured for your project for identification by the CLI.
    - All Flutter flavors and configuration settings in the gradle/Xcode config are correct.
    - Any code in your project referencing `systemControllers` environment is validated.

3. **Configuration Verification**: To verify if the configuration is accurate, deploy only the rules for now using the command: `firebase deploy --only firestore/storage`. Confirm you are in the right environment by executing `firebase use $theNameYouCalledTheProject`.
4. **Deploy Functions**: Deploy the functions to complete the GCP deployment and Secret setup. Ensure to deploy the Firebase extensions using `firebase deploy`, then confirm all extensions are correctly configured post-deployment.

> Note: Some services may require activation before usage. Firebase services used in this project include: Authentication, Firestore, Storage, App Check, Hosting, App Distribution, Crash Analytics, and Cloud Messaging.

The following authentication options are required:

- Sign-in providers: Email, Phone, Google, Apple, Facebook
- Email link: Disabled
- User account linking: Enabled
- SMS region policy: Disabled

Avoid using test phone numbers for live environments. Configure the Google auth provider later to enable SSO on Flamelink. Use the Services ID of `com.positiveplusone.apple.signinkey` for the Apple Auth Provider and configure all callbacks in relevant auth providers, such as Facebook.

## Google Cloud Configuration

While most of Google Cloud is automatically configured by Firebase, we use additional features related to data access:

- Google Serverless VPC
- Redis
- Google Secrets Manager
- Google Places API
- Autocomplete

1. **Deploy Scripts**: We use GSVPC to connect to Redis from our functions. To deploy these components, scripts are available for assistance. After connecting to the correct project via `firebase use`, execute `cache-setup.sh` from the scripts folder.

> Note: Only privileged users can execute these commands. GCP uses a different user account than the Firebase CLI. Thus, adjust the setup script variables prior to deployment.

2. **Secret Manager**: Before running the scripts, enable the secret manager. Set the correct project in the gcloud CLI and Firebase CLI prior to deployment:

- `gcloud projects list` and `gcloud config set project PROJECT_ID`
- `firebase use "projectId"`
- Run the commands from the app folder
- Update `projectId` and `storageRole` properties in the setup scripts

If you encounter any issues during setup, ensure that your Firebase project is on the Pay-As-You-Go plan, with a valid card attached. Depending on your environment's scale, you may want to adjust the setup scripts.

> Note: The Places/Autocomplete API, which is used for billing, doesn't require setup for each environment. Add a new key manually and edit the workspace files which setup the environments (`launch.json` for VS Code).

## Secret/Environment Configuration

Upon completion, add the following keys to Google Secret Manager to expose the third-party services to the environment:

```
//* API keys
OCCASION_GENIUS_API_KEY
STREAM_API_KEY
STREAM_FEEDS_API_KEY
ALGOLIA_API_KEY
MAPS_API_KEY

//* Secret keys
STREAM_API_SECRET
STREAM_FEEDS_API_SECRET
ALGOLIA_APP_ID
```

## Third-Party Configuration

### Mixpanel Configuration

Mixpanel is used for data analytics. To configure it, create a new project on the Mixpanel dashboard and add a case for it within the application.

### Flamelink Configuration

Flamelink maps our data without configuring any rules for data storage. To use Flamelink, provide it access to our Firebase environment and restore the schema from another environment. During the Flamelink configuration, you'll be asked to create a new webapp within the new Firebase project. The configuration from this process then needs to be added to Flamelink.

> Note: During the creation of a new project, issues might arise with permissions if you're using tailored permissions. Temporarily change the Firestore rules to open for logged-in users while processing.

### Get Stream Configuration

Log in and choose to clone the Sandbox environment to get all of the correct configuration. Then wire it in via SecretsManager.

### Codemagic Configuration

Our branches have triggers; if you tag a build suffixed with either (-dev,-prod,-staging), it triggers a build for those environments. Copy the new app identifiers over to the new pipeline, and any new certificates if you're not using existing ones.

### Resize Images Extension Configuration

The Resize Images extension is a Firebase marketplace service that allows our content to be resized by cloud functions. The configuration should match these settings:

- Sizes: 64x64, 256x256, 512x512
- Deletion of original file: false
- Make resized images public: false
- Paths that contain images: /users/*/profileImages
- Preferred type: jpeg
- GIF/WEBP support: true
- Functions memory: environment dependent, usually 1GB
- Backfill: true

> Note: Paths might change as we further develop the application.
