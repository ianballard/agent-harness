const { test, expect } = require("playwright/test");

test("auth API supports signup, duplicate rejection, and login", async ({ request, baseURL }) => {
  const email = `user-${Date.now()}@example.com`;
  const signupPayload = {
    email,
    password: "password123",
    full_name: "Playwright User",
  };

  const signupResponse = await request.post(`${baseURL}/api/auth/signup`, {
    data: signupPayload,
  });

  expect(signupResponse.status()).toBe(201);
  await expect(signupResponse.json()).resolves.toMatchObject({
    email,
    full_name: "Playwright User",
  });

  const duplicateResponse = await request.post(`${baseURL}/api/auth/signup`, {
    data: signupPayload,
  });

  expect(duplicateResponse.status()).toBe(409);
  await expect(duplicateResponse.json()).resolves.toEqual({
    detail: "A user with this email already exists.",
  });

  const loginResponse = await request.post(`${baseURL}/api/auth/login`, {
    data: { email, password: "password123" },
  });

  expect(loginResponse.ok()).toBeTruthy();
  await expect(loginResponse.json()).resolves.toMatchObject({
    token_type: "bearer",
  });
});
