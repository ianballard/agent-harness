import { cleanup, render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import App from "./App";
import { AuthServiceError } from "./services/authService";

vi.mock("./services/authService", async () => {
  const actual = await vi.importActual("./services/authService");

  return {
    ...actual,
    signup: vi.fn(),
    login: vi.fn(),
    getProfile: vi.fn(),
  };
});

import { getProfile, login, signup } from "./services/authService";

describe("App", () => {
  beforeEach(() => {
    window.sessionStorage.clear();
    vi.clearAllMocks();
  });

  afterEach(() => {
    cleanup();
  });

  it("switches views, signs in, and renders the profile surface", async () => {
    const user = userEvent.setup();

    login.mockResolvedValue({ access_token: "token-123", token_type: "bearer" });
    getProfile.mockResolvedValue({
      id: 7,
      email: "person@example.com",
      full_name: "Example Person",
      created_at: "2026-04-26T20:00:00Z",
    });

    render(<App />);

    await user.click(screen.getByRole("button", { name: "Sign up" }));
    expect(screen.getByRole("button", { name: "Create account" })).toBeInTheDocument();

    await user.click(screen.getByRole("button", { name: "Log in" }));
    await user.type(screen.getByLabelText("Email"), "person@example.com");
    await user.type(screen.getByLabelText("Password"), "password123");
    await user.click(screen.getAllByRole("button", { name: "Log in" }).at(-1));

    await waitFor(() =>
      expect(screen.getByRole("heading", { name: "Example Person" })).toBeInTheDocument()
    );
    expect(screen.getByText("person@example.com")).toBeInTheDocument();
    expect(window.sessionStorage.getItem("myproject.accessToken")).toBe("token-123");
  });

  it("shows duplicate signup errors returned by the service layer", async () => {
    const user = userEvent.setup();

    signup.mockRejectedValue(
      new AuthServiceError("duplicate_signup", "A user with this email already exists.", 409)
    );

    render(<App />);

    await user.click(screen.getByRole("button", { name: "Sign up" }));
    await user.type(screen.getByLabelText("Full name"), "Existing User");
    await user.type(screen.getByLabelText("Email"), "person@example.com");
    await user.type(screen.getByLabelText("Password"), "password123");
    await user.click(screen.getByRole("button", { name: "Create account" }));

    await waitFor(() =>
      expect(screen.getByText("A user with this email already exists.")).toBeInTheDocument()
    );
  });
});
