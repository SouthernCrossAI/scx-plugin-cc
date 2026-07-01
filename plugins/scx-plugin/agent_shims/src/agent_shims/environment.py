import os

DEFAULT_SCX_BASE_URL = "https://api.scx.ai/v1"


def get_scx_key():
    """Retrieve the SCX API key from environment variables."""
    key = os.environ.get("SCX_API_KEY")
    if not key:
        raise EnvironmentError(
            "SCX API key not found. Please set "
            "SCX_API_KEY in your environment."
        )
    return key


def get_scx_base_url() -> str:
    """Base URL for the SCX-compatible API.

    Reads SCX_BASE_URL (default: https://api.scx.ai/v1).
    Strips a trailing /chat/completions path if pasted from the docs.
    """
    raw = os.environ.get("SCX_BASE_URL") or DEFAULT_SCX_BASE_URL
    url = raw.rstrip("/")
    if url.endswith("/chat/completions"):
        url = url[: -len("/chat/completions")].rstrip("/")
    return url
