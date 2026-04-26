const { test, expect } = require("playwright/test");

test("frontend auth shell supports signup, duplicate signup errors, login, and profile retrieval", async ({
  page,
}) => {
  const email = `ui-user-${Date.now()}@example.com`;

  await page.goto("http://127.0.0.1:5173");

  await page.getByRole("button", { name: "Sign up" }).click();
  await page.getByLabel("Full name").fill("Frontend User");
  await page.getByLabel("Email").fill(email);
  await page.getByLabel("Password").fill("password123");
  await page.getByRole("button", { name: "Create account" }).click();

  await expect(page.getByText(`Account created for ${email}. Sign in to continue.`)).toBeVisible();
  await expect(page.getByLabel("Email")).toHaveValue(email);

  await page.getByRole("button", { name: "Sign up" }).click();
  await page.getByLabel("Full name").fill("Frontend User");
  await page.getByLabel("Email").fill(email);
  await page.getByLabel("Password").fill("password123");
  await page.getByRole("button", { name: "Create account" }).click();

  await expect(page.getByText("A user with this email already exists.")).toBeVisible();

  await page.getByRole("button", { name: "Log in" }).click();
  await page.getByLabel("Password").fill("wrong-password");
  await page.getByRole("button", { name: "Log in" }).click();

  await expect(page.getByText("Invalid email or password.")).toBeVisible();

  await page.getByLabel("Password").fill("password123");
  await page.getByRole("button", { name: "Log in" }).click();

  await expect(page.getByRole("heading", { name: "Frontend User" })).toBeVisible();
  await expect(page.getByText(email)).toBeVisible();
});
