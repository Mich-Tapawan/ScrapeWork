"""Shared raw-job contract for scraper → n8n handoff."""

from __future__ import annotations

from dataclasses import asdict, dataclass
from typing import Any


@dataclass
class RawJob:
    platform: str
    external_id: str
    title: str
    raw_description: str
    url: str
    client_name: str | None = None
    budget_or_rate: str | None = None
    posted_at: str | None = None

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)
