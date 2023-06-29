# A Guide to Setting Up Your PP1 Environment

Welcome to our in-depth guide on setting up your development environment. This guide will assist you in establishing the ideal environment for your programming project, featuring detailed steps and additional information to aid in understanding each process. 

---

## Section 1: Firebase Configuration 

Let's initiate the journey of setting up your development environment by configuring Firebase for your project. Follow the steps below:

1. **Initiate the Project**: Create a new application on Firebase to serve as the foundation of your project.

2. **Link the Project**: Associate your new project with the application. The following tasks must be fulfilled to achieve proper linking:

    - A correctly configured `.firebaserc` file is crucial as it identifies your project to the Firebase Command Line Interface (CLI).
    - Flutter flavors and settings should be accurately configured in the gradle/Xcode config.
    - Any piece of code referencing `systemControllers` environment within your project should be checked for validity.

3. **Verify the Configuration**: Now, let's validate whether your configuration is correct. For this purpose, deploy only the rules for now using the command: `firebase deploy --only firestore/storage`. To ascertain that you're working within the correct environment, execute `firebase use $theNameYouCalledTheProject`.

4. **Complete the Deployment**: Lastly, deploy the functions for finalizing the Google Cloud Platform (GCP) deployment and Secret setup. The deployment of Firebase extensions can be achieved using `firebase deploy`. Upon completion, ensure that all extensions are correctly configured.

> **Note**: Certain Firebase services might necessitate activation before usage. For this project, you'll be utilizing Authentication, Firestore, Storage, App Check, Hosting, App Distribution, Crash Analytics, and Cloud Messaging.

The next step involves setting up authentication options, which include:

- Sign-in providers: Email, Phone, Google, Apple, Facebook
- Email link: Disabled
- User account linking: Enabled
- SMS region policy: Disabled

Do remember to abstain from using test phone numbers in live environments. Configuration of Google auth provider should be undertaken at a later stage to activate Single Sign-On (SSO) on Flamelink. For the Apple Auth Provider, the Services ID `com.positiveplusone.apple.signinkey` should be used. Also, remember to set up all callbacks in relevant auth providers such as Facebook.

---

## Section 2: Google Cloud Configuration 

While Firebase does handle a majority of Google Cloud configurations, we'll be utilizing a few additional features pertaining to data access. These include:

- Google Serverless VPC
- Redis
- Google Secrets Manager
- Google Places API
- Autocomplete

Here are the steps to follow:

1. **Deploy Scripts**: Scripts are at your disposal for deploying components. After associating with the correct project via `firebase use`, run `cache-setup.sh` from the scripts folder.

> **Note**: Only users with elevated permissions can run these commands. GCP uses a distinct user account from the Firebase CLI. Thus, tweak the setup script variables prior to deployment.

2. **Manage Secrets**: Before the script run, activate the secret manager. Ensure to set the correct project in the gcloud CLI and Firebase CLI before deployment:

- Run `gcloud projects list` and `gcloud config set project PROJECT_ID`.
- Use the command `firebase use "projectId"`.
- Execute the commands from the app folder.
- Adjust the `projectId` and `storageRole` properties in the setup scripts.

If you stumble upon any issues during setup, check whether your Firebase project is on the Pay-As-You-Go plan with a valid credit card linked. Depending on the scale of your environment, you may need to modify the setup scripts.

> **Note**: The Places/Autocomplete API, used for billing, does not require setup for each environment. Manually add a new key and edit the workspace files which setup the environments (`launch.json` for VS Code).

---

## Section 3: Secret/Environment Configuration 

Upon completing the above steps, insert the following keys into Google Secret Manager to make the third-party services available in the environment:

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


---

## Section 4: Third-Party Configuration 

In this section, we'll walk through configuring various third-party services.

### 4.1 Mixpanel Configuration

Mixpanel is a data analytics tool utilized by us. To configure it, create a new project on the Mixpanel dashboard and add a case for it within the application.

### 4.2 Flamelink Configuration

Flamelink allows mapping our data without any rules configuration for data storage. To use Flamelink, grant it access to our Firebase environment and restore the schema from another environment. During this process, Flamelink will prompt you to create a new webapp within the new Firebase project. Subsequently, add the configuration generated by this process to Flamelink.

> **Note**: During the new project creation, permission issues may occur if you're using tailored permissions. Temporarily adjust the Firestore rules to be open for logged-in users during this process.

### 4.3 Get Stream Configuration

Log into Get Stream and clone the Sandbox environment to acquire all necessary configurations. Wire this configuration via SecretsManager.

### 4.4 Codemagic Configuration

Our branches use triggers. Tagging a build suffixed with (-dev,-prod,-staging) will initiate a build for the corresponding environment. For a new pipeline, copy over the new app identifiers and any new certificates, if you're not using existing ones.

### 4.5 Resize Images Extension Configuration

The Resize Images extension is a Firebase marketplace service that enables content resizing via cloud functions. The configuration should comply with these settings:

- Sizes: 64x64, 256x256, 512x512
- Deletion of original file: false
- Make resized images public: false
- Paths that contain images: /users/*/profileImages
- Preferred type: jpeg
- GIF/WEBP support: true
- Functions memory: environment dependent, usually 1GB
- Backfill: true

> **Note**: Paths may undergo changes as we continue to develop the application.

And there you have it! This comprehensive guide will help you successfully establish your development environment. Happy programming!
