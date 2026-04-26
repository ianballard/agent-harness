React + FastAPI + SQLite web app with auth and user profile.

## Dev Setup

### Backend

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload
```

API runs at http://localhost:8000. Docs at http://localhost:8000/docs.
Copy `.env.example` to `.env` and adjust values if you need non-default local settings.

### Frontend

```bash
cd frontend
npm install
npm run dev
```

App runs at http://localhost:5173. API requests to `/api/*` are proxied to the backend at http://127.0.0.1:8000 automatically.

## Architecture

- `backend/` — FastAPI app scaffold with app factory, router wiring, and shared settings
- `frontend/` — Vite + React SPA with an auth service layer for signup, login, and profile retrieval

## Notes

- SQLite DB created automatically at `backend/app.db` on first run
- JWT secret defaults to a dev value — set `SECRET_KEY` env var in production
- No email verification, no OAuth, no refresh tokens — intentionally minimal

## Testing

### Frontend

```bash
cd frontend
npm test
```

Runs Vitest in single-run mode. Test files follow the `*.test.js` convention alongside source files.

### Backend

```bash
cd backend
source .venv/bin/activate   # activate virtualenv first
pytest
```

Test files live in `backend/tests/`. Pytest is configured via `pyproject.toml`.

### E2E

Make sure backend dependencies are installed first:

```bash
cd backend
source .venv/bin/activate
pip install -r requirements.txt
```

Install frontend dependencies once if you have not already:

```bash
cd frontend
npm install
```

Then run the smoke tests from the repo root:

```bash
npx playwright test e2e/backend-scaffold.spec.js e2e/frontend-auth.spec.js
```

Playwright starts the backend and frontend dev servers automatically from the repo configuration.
