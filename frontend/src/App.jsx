import { useEffect, useState } from "react";
import {
  AuthServiceError,
  getProfile,
  login as loginRequest,
  signup as signupRequest,
} from "./services/authService";

const TOKEN_STORAGE_KEY = "myproject.accessToken";

const emptySignupForm = {
  email: "",
  password: "",
  fullName: "",
};

const emptyLoginForm = {
  email: "",
  password: "",
};

export default function App() {
  const [activeView, setActiveView] = useState("login");
  const [signupForm, setSignupForm] = useState(emptySignupForm);
  const [loginForm, setLoginForm] = useState(emptyLoginForm);
  const [token, setToken] = useState(() => window.sessionStorage.getItem(TOKEN_STORAGE_KEY) ?? "");
  const [profile, setProfile] = useState(null);
  const [errorMessage, setErrorMessage] = useState("");
  const [statusMessage, setStatusMessage] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isLoadingProfile, setIsLoadingProfile] = useState(false);

  useEffect(() => {
    if (!token) {
      window.sessionStorage.removeItem(TOKEN_STORAGE_KEY);
      setProfile(null);
      return;
    }

    window.sessionStorage.setItem(TOKEN_STORAGE_KEY, token);
    void loadProfile(token);
  }, [token]);

  async function loadProfile(accessToken) {
    setIsLoadingProfile(true);
    setErrorMessage("");

    try {
      const nextProfile = await getProfile(accessToken);
      setProfile(nextProfile);
      setActiveView("profile");
    } catch (error) {
      setToken("");
      setProfile(null);
      setActiveView("login");
      setErrorMessage(resolveMessage(error, "Unable to load your profile right now."));
    } finally {
      setIsLoadingProfile(false);
    }
  }

  async function handleSignupSubmit(event) {
    event.preventDefault();
    setIsSubmitting(true);
    setErrorMessage("");
    setStatusMessage("");

    try {
      const createdUser = await signupRequest({
        email: signupForm.email,
        password: signupForm.password,
        full_name: signupForm.fullName,
      });
      setSignupForm(emptySignupForm);
      setStatusMessage(`Account created for ${createdUser.email}. Sign in to continue.`);
      setActiveView("login");
      setLoginForm((current) => ({ ...current, email: createdUser.email }));
    } catch (error) {
      setErrorMessage(resolveMessage(error, "Unable to create your account right now."));
    } finally {
      setIsSubmitting(false);
    }
  }

  async function handleLoginSubmit(event) {
    event.preventDefault();
    setIsSubmitting(true);
    setErrorMessage("");
    setStatusMessage("");

    try {
      const response = await loginRequest(loginForm);
      setToken(response.access_token);
      setLoginForm((current) => ({ ...current, password: "" }));
    } catch (error) {
      setErrorMessage(resolveMessage(error, "Unable to sign you in right now."));
    } finally {
      setIsSubmitting(false);
    }
  }

  function handleLogout() {
    setToken("");
    setProfile(null);
    setStatusMessage("Signed out.");
    setErrorMessage("");
    setActiveView("login");
  }

  function switchView(nextView) {
    setActiveView(nextView);
    setErrorMessage("");
    setStatusMessage("");
  }

  return (
    <div className="app-shell">
      <div className="aurora aurora-left" />
      <div className="aurora aurora-right" />
      <main className="panel">
        <section className="panel-copy">
          <p className="eyebrow">MyProject</p>
          <h1>Auth workflow shell</h1>
          <p className="lede">
            A browser-ready shell for signup, login, and profile retrieval against the FastAPI auth API.
          </p>
          <div className="contract-card">
            <h2>API boundary</h2>
            <ul>
              <li>`POST /api/auth/signup` creates an account.</li>
              <li>`POST /api/auth/login` returns a bearer token.</li>
              <li>`GET /api/profile` reads the authenticated profile.</li>
            </ul>
          </div>
        </section>

        <section className="panel-form">
          <nav className="view-switcher" aria-label="Authentication views">
            <button
              className={activeView === "login" ? "active" : ""}
              type="button"
              onClick={() => switchView("login")}
            >
              Log in
            </button>
            <button
              className={activeView === "signup" ? "active" : ""}
              type="button"
              onClick={() => switchView("signup")}
            >
              Sign up
            </button>
            <button
              className={activeView === "profile" ? "active" : ""}
              type="button"
              onClick={() => switchView(token ? "profile" : "login")}
              disabled={!token && !profile}
            >
              Profile
            </button>
          </nav>

          {statusMessage ? <p className="banner banner-success">{statusMessage}</p> : null}
          {errorMessage ? <p className="banner banner-error">{errorMessage}</p> : null}

          {activeView === "signup" ? (
            <form className="auth-form" onSubmit={handleSignupSubmit}>
              <label>
                <span>Full name</span>
                <input
                  autoComplete="name"
                  name="fullName"
                  required
                  value={signupForm.fullName}
                  onChange={(event) =>
                    setSignupForm((current) => ({ ...current, fullName: event.target.value }))
                  }
                />
              </label>
              <label>
                <span>Email</span>
                <input
                  autoComplete="email"
                  name="signupEmail"
                  required
                  type="email"
                  value={signupForm.email}
                  onChange={(event) =>
                    setSignupForm((current) => ({ ...current, email: event.target.value }))
                  }
                />
              </label>
              <label>
                <span>Password</span>
                <input
                  autoComplete="new-password"
                  minLength={8}
                  name="signupPassword"
                  required
                  type="password"
                  value={signupForm.password}
                  onChange={(event) =>
                    setSignupForm((current) => ({ ...current, password: event.target.value }))
                  }
                />
              </label>
              <button type="submit" disabled={isSubmitting}>
                {isSubmitting ? "Creating account..." : "Create account"}
              </button>
            </form>
          ) : null}

          {activeView === "login" ? (
            <form className="auth-form" onSubmit={handleLoginSubmit}>
              <label>
                <span>Email</span>
                <input
                  autoComplete="email"
                  name="loginEmail"
                  required
                  type="email"
                  value={loginForm.email}
                  onChange={(event) =>
                    setLoginForm((current) => ({ ...current, email: event.target.value }))
                  }
                />
              </label>
              <label>
                <span>Password</span>
                <input
                  autoComplete="current-password"
                  name="loginPassword"
                  required
                  type="password"
                  value={loginForm.password}
                  onChange={(event) =>
                    setLoginForm((current) => ({ ...current, password: event.target.value }))
                  }
                />
              </label>
              <button type="submit" disabled={isSubmitting || isLoadingProfile}>
                {isSubmitting ? "Signing in..." : "Log in"}
              </button>
            </form>
          ) : null}

          {activeView === "profile" ? (
            <section className="profile-card">
              <div>
                <p className="profile-label">Signed in profile</p>
                {isLoadingProfile ? <p>Loading profile...</p> : null}
                {profile ? (
                  <>
                    <h2>{profile.full_name}</h2>
                    <p>{profile.email}</p>
                    <p>User ID: {profile.id}</p>
                    <p>Created: {new Date(profile.created_at).toLocaleString()}</p>
                  </>
                ) : null}
              </div>
              <button type="button" className="secondary" onClick={handleLogout}>
                Log out
              </button>
            </section>
          ) : null}
        </section>
      </main>
    </div>
  );
}

function resolveMessage(error, fallbackMessage) {
  if (error instanceof AuthServiceError) {
    return error.message;
  }

  if (error instanceof Error && error.message) {
    return error.message;
  }

  return fallbackMessage;
}
