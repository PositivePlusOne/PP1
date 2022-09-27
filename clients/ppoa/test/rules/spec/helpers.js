const firebase = require("@firebase/testing");
const fs = require("fs");

const rules = fs.readFileSync("../../firestore.rules", "utf8");
const adminRules = fs.readFileSync("./spec/admin.rules", "utf8");
const seed = require("./seed.json");

module.exports.setup = async (auth) => {
  const projectId = `rules-spec-${Date.now()}`;

  const app = firebase.initializeTestApp({
    projectId,
    auth,
  });

  const db = app.firestore();
  await firebase.loadFirestoreRules({
    projectId,
    rules: adminRules,
  });

  //* Seed data while admin rules are applied
  const seedFutures = Object.entries(seed).map(entry => db.doc(entry[0]).set(entry[1]));
  await Promise.all(seedFutures);

  // const testRef = await db.collection('fl_content').doc('1').get();
  // console.log(`Got sample data: ${JSON.stringify(testRef.data())}`);

  await firebase.loadFirestoreRules({
    projectId,
    rules: rules,
  });

  return db;
};

module.exports.teardown = async () => {
  Promise.all(firebase.apps().map((app) => app.delete()));
};

expect.extend({
  async toAllow(x) {
    let pass = false;
    try {
      await firebase.assertSucceeds(x);
      pass = true;
    } catch (err) {}

    return {
      pass,
      message: () => "Expected Firebase operation to be allowed, but it failed",
    };
  },
});

expect.extend({
  async toDeny(x) {
    let pass = false;
    try {
      await firebase.assertFails(x);
      pass = true;
    } catch (err) {}
    return {
      pass,
      message: () =>
        "Expected Firebase operation to be denied, but it was allowed",
    };
  },
});
