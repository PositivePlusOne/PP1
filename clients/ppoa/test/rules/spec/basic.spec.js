const { setup, teardown } = require("./helpers");
const { fakeSuperAdminUser } = require("./fakes/fake.users");

describe("Basic database rules", () => {
  afterAll(async () => {
    await teardown();
  });

  test("Fail when reading and writing to an unknown collection, whilst unauthenticated", async () => {
    let db = await setup();
    let ref = db.collection("some-nonexistent-collection");

    await expect(ref.get()).toDeny();
    await expect(ref.add({})).toDeny();
  });

  test("Fail when reading and writing to an unknown collection, whilst authenticated", async () => {
    let db = await setup(fakeSuperAdminUser);
    let ref = db.collection("some-nonexistent-collection");

    await expect(ref.get()).toDeny();
    await expect(ref.add({})).toDeny();
  });
});
