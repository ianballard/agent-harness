from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_root_exposes_service_metadata() -> None:
    response = client.get("/")

    assert response.status_code == 200
    assert response.json() == {
        "service": "MyProject API",
        "environment": "development",
        "api": "/api",
    }


def test_health_endpoint_returns_ok() -> None:
    response = client.get("/api/health")

    assert response.status_code == 200
    assert response.json() == {"status": "ok"}

