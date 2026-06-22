import os

def get_scx_key():
    """Retrieve the SCX API key from environment variables."""
    key = os.environ.get("SCX_API_KEY")
    if not key:
        raise EnvironmentError(
            "SCX API key not found. Please set "
            "SCX_API_KEY in your environment."
        )
    return key

def get_anthropic_key():
    """Retrieve the Anthropic API key from environment variables."""
    key = os.environ.get("ANTHROPIC_API_KEY")
    if not key:
        raise EnvironmentError(
            "Anthropic API key not found. Please set "
            "ANTHROPIC_API_KEY in your environment."
        )
    return key

def get_openai_key():
    """Retrieve the OpenAI API key from environment variables."""
    key = os.environ.get("OPENAI_API_KEY")
    if not key:
        raise EnvironmentError(
            "OpenAI API key not found. Please set "
            "OPENAI_API_KEY in your environment."
        )
    return key