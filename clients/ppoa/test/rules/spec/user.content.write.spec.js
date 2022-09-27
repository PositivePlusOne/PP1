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

  test("User can create content for themselves with write rules of any", async () => {
    const data = buildContent("mockuser", "events", "all", "all");
    await expect(contentRef.add(data)).toAllow();
  });

  test("User cannot create content for others with write rules of any", async () => {
    const data = buildContent("mockuser2", "events", "all", "all");
    await expect(contentRef.add(data)).toDeny();
  });

  test("User can create content for themselves with write rules of users", async () => {
    const data = buildContent("mockuser", "events", "users", "users");
    await expect(contentRef.add(data)).toAllow();
  });

  test("User cannot create content for others with write rules of users", async () => {
    const data = buildContent("mockuser2", "events", "users", "users");
    await expect(contentRef.add(data)).toDeny();
  });

  test("User can create content for themselves with write rules of creator", async () => {
    const data = buildContent("mockuser", "events", "creator", "creator");
    await expect(contentRef.add(data)).toAllow();
  });

  test("User cannot create content for others with write rules of creator", async () => {
    const data = buildContent("mockuser2", "events", "creator", "creator");
    await expect(contentRef.add(data)).toDeny();
  });

  //* User data we do not want modified will be created under admins (like user metadata)
  test("User cannot create content for themselves with write rules of none", async () => {
    const data = buildContent("mockuser", "events", "none", "none");
    await expect(contentRef.add(data)).toAllow();
  });

  test("User can create content for others with write rules of none", async () => {
    const data = buildContent("mockuser2", "events", "none", "none");
    await expect(contentRef.add(data)).toDeny();
  });
});
