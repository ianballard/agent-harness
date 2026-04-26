from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.router import api_router
from app.config import get_settings


def create_app() -> FastAPI:
    settings = get_settings()
    app = FastAPI(
        title=settings.app_name,
        docs_url=settings.docs_url,
        openapi_url=settings.openapi_url,
    )

    app.add_middleware(
        CORSMiddleware,
        allow_origins=list(settings.cors_origins),
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    app.include_router(api_router, prefix=settings.api_prefix)

    @app.get("/", tags=["meta"])
    def read_root() -> dict[str, str]:
        return {
            "service": settings.app_name,
            "environment": settings.environment,
            "api": settings.api_prefix,
        }

    return app


app = create_app()

