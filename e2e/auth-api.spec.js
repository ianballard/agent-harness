const { test, expect } = require("playwright/test");

test("auth API supports signup, login, and authenticated profile retrieval", async ({ request, baseURL }) => {
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
  const loginBody = await loginResponse.json();

  expect(loginBody).toMatchObject({
    token_type: "bearer",
  });

  const unauthorizedProfileResponse = await request.get(`${baseURL}/api/profile`);

  expect(unauthorizedProfileResponse.status()).toBe(401);

  const profileResponse = await request.get(`${baseURL}/api/profile`, {
    headers: {
      Authorization: `Bearer ${loginBody.access_token}`,
    },
  });

  expect(profileResponse.ok()).toBeTruthy();
  await expect(profileResponse.json()).resolves.toMatchObject({
    email,
    full_name: "Playwright User",
  });
});
