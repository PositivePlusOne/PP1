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