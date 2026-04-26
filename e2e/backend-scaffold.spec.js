const { test, expect } = require("playwright/test");

test("backend scaffold responds on health endpoint", async ({ request, baseURL }) => {
  const response = await request.get(`${baseURL}/api/health`);

  expect(response.ok()).toBeTruthy();
  await expect(response.json()).resolves.toEqual({ status: "ok" });
});
