import { ApiError, apiRequest } from "./apiClient";

export class AuthServiceError extends Error {
  constructor(code, message, status) {
    super(message);
    this.name = "AuthServiceError";
    this.code = code;
    this.status = status;
  }
}

export async function signup(payload) {
  try {
    return await apiRequest("/auth/signup", {
      method: "POST",
      body: JSON.stringify(payload),
    });
  } catch (error) {
    if (error instanceof ApiError && error.status === 409) {
      throw new AuthServiceError("duplicate_signup", error.message, error.status);
    }

    throw toServiceError(error, "signup_failed", "Unable to create your account.");
  }
}

export async function login(payload) {
  try {
    return await apiRequest("/auth/login", {
      method: "POST",
      body: JSON.stringify(payload),
    });
  } catch (error) {
    if (error instanceof ApiError && error.status === 401) {
      throw new AuthServiceError("invalid_login", error.message, error.status);
    }

    throw toServiceError(error, "login_failed", "Unable to sign in.");
  }
}

export async function getProfile(accessToken) {
  try {
    return await apiRequest("/profile", {
      method: "GET",
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    });
  } catch (error) {
    throw toServiceError(error, "profile_failed", "Unable to load your profile.");
  }
}

function toServiceError(error, code, fallbackMessage) {
  if (error instanceof AuthServiceError) {
    return error;
  }

  if (error instanceof ApiError) {
    return new AuthServiceError(code, error.message, error.status);
  }

  if (error instanceof Error) {
    return new AuthServiceError(code, error.message, undefined);
  }

  return new AuthServiceError(code, fallbackMessage, undefined);
}
