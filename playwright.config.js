// Backend scaffold smoke test coverage uses Playwright's request fixture.
module.exports = {
  testDir: "./e2e",
  timeout: 30_000,
  use: {
    baseURL: "http://127.0.0.1:8000",
  },
  webServer: [
    {
      command:
        "cd backend && source .venv/bin/activate && uvicorn main:app --host 127.0.0.1 --port 8000",
      url: "http://127.0.0.1:8000",
      reuseExistingServer: true,
      timeout: 30_000,
    },
    {
      command: "cd frontend && npm run dev -- --host 127.0.0.1 --port 5173",
      url: "http://127.0.0.1:5173",
      reuseExistingServer: true,
      timeout: 30_000,
    },
  ],
};
