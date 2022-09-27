const { setup, teardown } = require("./helpers");
const { buildContent } = require("./fakes/fake.content");

describe("User content database rules", () => {
  let db;
  let contentRef;

  beforeAll(async () => {
    db = await setup({ uid: "mockuser" });
    contentRef = db.collection("fl_content");
  });

  afterAll(async () => {
    await teardown();
  });

  test("User can read their own content if rules are set to all", async () => {
    contentRef = db.doc('fl_content/1');
    await expect(contentRef.get()).toAllow();
  });

  test("User can read other users content if rules are set to all", async () => {
    contentRef = db.doc('fl_content/2');
    await expect(contentRef.get()).toAllow();
  });

  test("User can read their own content if rules are set to users", async () => {
    contentRef = db.doc('fl_content/3');
    await expect(contentRef.get()).toAllow();
  });

  test("User can read other users content if rules are set to users", async () => {
    contentRef = db.doc('fl_content/4');
    await expect(contentRef.get()).toAllow();
  });

  test("User can read their own content if rules are set to creator", async () => {
    contentRef = db.doc('fl_content/5');
    await expect(contentRef.get()).toAllow();
  });

  test("User cannot read other users content if rules are set to creator", async () => {
    contentRef = db.doc('fl_content/6');
    await expect(contentRef.get()).toDeny();
  });

  test("User cannot read their own content if rules are set to none", async () => {
    contentRef = db.doc('fl_content/7');
    await expect(contentRef.get()).toDeny();
  });

  test("User cannot read other users content if rules are set to none", async () => {
    contentRef = db.doc('fl_content/8');
    await expect(contentRef.get()).toDeny();
  });
});
