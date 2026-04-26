import { afterEach, describe, expect, it, vi } from "vitest";
import { AuthServiceError, getProfile, login, signup } from "./authService";

describe("authService", () => {
  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("maps duplicate signup responses to duplicate_signup errors", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn().mockResolvedValue({
        ok: false,
        status: 409,
        headers: {
          get: () => "application/json",
        },
        json: async () => ({ detail: "A user with this email already exists." }),
      })
    );

    await expect(
      signup({
        email: "person@example.com",
        password: "password123",
        full_name: "Existing User",
      })
    ).rejects.toMatchObject({
      code: "duplicate_signup",
      message: "A user with this email already exists.",
    });
  });

  it("maps invalid login responses to invalid_login errors", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn().mockResolvedValue({
        ok: false,
        status: 401,
        headers: {
          get: () => "application/json",
        },
        json: async () => ({ detail: "Invalid email or password." }),
      })
    );

    await expect(
      login({
        email: "person@example.com",
        password: "wrong-password",
      })
    ).rejects.toMatchObject({
      code: "invalid_login",
      message: "Invalid email or password.",
    });
  });

  it("sends the bearer token when reading the profile", async () => {
    const fetchMock = vi.fn().mockResolvedValue({
      ok: true,
      headers: {
        get: () => "application/json",
      },
      json: async () => ({
        id: 1,
        email: "person@example.com",
        full_name: "Example Person",
        created_at: "2026-04-26T20:00:00Z",
      }),
    });
    vi.stubGlobal("fetch", fetchMock);

    const profile = await getProfile("token-123");

    expect(profile.email).toBe("person@example.com");
    expect(fetchMock).toHaveBeenCalledWith(
      "/api/profile",
      expect.objectContaining({
        method: "GET",
        headers: expect.objectContaining({
          Authorization: "Bearer token-123",
        }),
      })
    );
  });

  it("preserves the auth service error type on failures", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn().mockResolvedValue({
        ok: false,
        status: 500,
        headers: {
          get: () => "application/json",
        },
        json: async () => ({ detail: "Server error." }),
      })
    );

    await expect(login({ email: "person@example.com", password: "password123" })).rejects.toBeInstanceOf(
      AuthServiceError
    );
  });
});
