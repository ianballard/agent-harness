// Backend scaffold smoke test coverage uses Playwright's request fixture.
module.exports = {
  testDir: "./e2e",
  timeout: 30_000,
  use: {
    baseURL: "http://127.0.0.1:8000",
  },
};
