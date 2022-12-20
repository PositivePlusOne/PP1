import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export namespace UserEndpoints {
  /**
   * Verifies a user has the correct documents available to start using the application.
   */
  export const verifyUserCreated = functions.https.onCall(
    async (_, context) => {
        const uid = context.auth?.uid || "";
        if (!(typeof uid === "string") || uid.length === 0) {
          throw new functions.https.HttpsError("unauthenticated", "You must be authenticated to call this function");
        }

        const firestore = admin.firestore();
        const publicDocumentSnapshot = await firestore.collection("public_users").doc(uid).get();
        const privateDocumentSnapshot = await firestore.collection("private_users").doc(uid).get();
        const systemDocumentSnapshot = await firestore.collection("system_users").doc(uid).get();

        if (!publicDocumentSnapshot.exists) {
            console.log(`Creating new public user ${uid}`);
            await firestore.collection("public_users").doc(uid).set({});
        }

        if (!privateDocumentSnapshot.exists) {
            console.log(`Creating new private user ${uid}`);
            await firestore.collection("private_users").doc(uid).set({});
        }

        if (!systemDocumentSnapshot.exists) {
            console.log(`Creating new system user ${uid}`);
            await firestore.collection("system_users").doc(uid).set({});
        }
    }
  );
}
