from dataclasses import dataclass
from functools import lru_cache
import os


def _split_csv(value: str) -> list[str]:
    return [item.strip() for item in value.split(",") if item.strip()]


@dataclass(frozen=True)
class Settings:
    app_name: str = "MyProject API"
    environment: str = "development"
    api_prefix: str = "/api"
    docs_url: str = "/docs"
    openapi_url: str = "/openapi.json"
    cors_origins: tuple[str, ...] = ("http://localhost:5173",)


@lru_cache
def get_settings() -> Settings:
    return Settings(
        app_name=os.getenv("APP_NAME", "MyProject API"),
        environment=os.getenv("APP_ENV", "development"),
        api_prefix=os.getenv("API_PREFIX", "/api"),
        docs_url=os.getenv("DOCS_URL", "/docs"),
        openapi_url=os.getenv("OPENAPI_URL", "/openapi.json"),
        cors_origins=tuple(
            _split_csv(os.getenv("CORS_ORIGINS", "http://localhost:5173"))
        ),
    )

