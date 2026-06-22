#!/usr/bin/env python3
import json
import sys
from pathlib import Path

try:
    from agent_shims.model import Model
    from agent_shims.model_parameters import insert_model
except ImportError:
    print("Error: agent_shims not installed. Run /setup first.")
    sys.exit(1)


MODELS = {
    "MiniMax-M2.7": {
        "context_length": 120000,
        "max_completion_tokens": 8000,
        "sampling_parameters": {"temperature": 1.0, "top_p": 0.95, "top_k": 40},
    },
    "coder": {
        "context_length": 120000,
        "max_completion_tokens": 8000,
        "sampling_parameters": {"temperature": 1.0, "top_p": 0.95, "top_k": 40},
    },
    "MAGPiE": {
        "context_length": 131072,
        "max_completion_tokens": 131072,
        "sampling_parameters": {"temperature": 1.0, "top_p": 0.95, "top_k": 40},
    },
    "gpt-5.4": {
        "context_length": 400000,
        "max_completion_tokens": 128000,
        "sampling_parameters": {"temperature": 1.0, "top_p": 0.95},
    },
    "claude-opus-4-7": {
        "context_length": 200000,
        "max_completion_tokens": 8192,
        "sampling_parameters": {"temperature": 1.0, "top_p": 0.95},
    },
}


def main():
    for name, params in MODELS.items():
        model = Model(
            id=name,
            context_length=params["context_length"],
            max_completion_tokens=params["max_completion_tokens"],
            sampling_parameters=params.get("sampling_parameters", {}),
        )
        insert_model(model)
        print(f"Inserted/updated: {name}")


if __name__ == "__main__":
    main()