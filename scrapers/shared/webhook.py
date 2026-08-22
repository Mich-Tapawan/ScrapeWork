"""POST normalized jobs to the n8n ingest webhook."""

from __future__ import annotations

import os
from typing import Any

import requests

from .types import RawJob


def post_to_n8n(job: RawJob, webhook_url: str | None = None) -> dict[str, Any]:
    url = webhook_url or os.environ.get("N8N_INGEST_WEBHOOK_URL")
    if not url:
        raise RuntimeError("N8N_INGEST_WEBHOOK_URL is not set")

    response = requests.post(url, json=job.to_dict(), timeout=30)
    response.raise_for_status()
    if not response.content:
        return {"ok": True}
    return response.json()
