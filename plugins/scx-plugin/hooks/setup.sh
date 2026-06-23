#!/bin/bash
set -e

if [[ -n "$PYENV_ROOT" ]] && [[ -d "$PYENV_ROOT/bin" ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - zsh)" 2>/dev/null || eval "$(pyenv init - bash)" 2>/dev/null
fi

CLAUDE_PLUGIN_DIR=$1
if [[ -z "$CLAUDE_PLUGIN_DIR" ]]; then
    echo "CLAUDE_PLUGIN_DIR not set -- exiting"
    exit 1
fi

find_python() {
    if [[ -n "$PYENV_VERSION" ]]; then
        local pyenv_path=$(pyenv prefix 2>/dev/null)/bin/python3
        if [[ -x "$pyenv_path" ]]; then
            echo "$pyenv_path"
            return 0
        fi
    fi
    if [[ -x "$HOME/.pyenv/versions/3.11.9/bin/python3" ]]; then
        echo "$HOME/.pyenv/versions/3.11.9/bin/python3"
        return 0
    fi
    for cmd in python3 python3.11 python3.12 python3.13 python3.14; do
        if command -v "$cmd" &> /dev/null; then
            local ver=$("$cmd" -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")' 2>/dev/null)
            if [[ "$ver" =~ ^3\.(11|[0-9]{2})$ ]]; then
                echo "$cmd"
                return 0
            fi
        fi
    done
    echo "python3"
}

PYTHON_CMD=$(find_python)
echo "Using Python: $PYTHON_CMD ($($PYTHON_CMD --version))"

if [ ! -d "${CLAUDE_PLUGIN_DIR}/.env" ]; then
    echo "Creating virtual environment..."
    $PYTHON_CMD -m venv "${CLAUDE_PLUGIN_DIR}/.env"
fi

echo "Upgrading pip..."
"${CLAUDE_PLUGIN_DIR}/.env/bin/pip" install --upgrade pip

SENTINEL="${CLAUDE_PLUGIN_DIR}/.env/.installed_version"
CURRENT_VERSION=$($PYTHON_CMD -c "import json; print(json.load(open('${CLAUDE_PLUGIN_DIR}/.claude-plugin/plugin.json'))['version'])" 2>/dev/null)

if [ ! -f "$SENTINEL" ] || [ "$(cat "$SENTINEL")" != "$CURRENT_VERSION" ]; then
    echo "Installing agent_shims..."
    "${CLAUDE_PLUGIN_DIR}/.env/bin/pip" install -e "${CLAUDE_PLUGIN_DIR}/agent_shims"
    echo "$CURRENT_VERSION" > "$SENTINEL"
fi

mkdir -p /tmp/scx-plugin/prompts /tmp/scx-plugin/progress

echo "export SCX_PLUGIN_PYTHON=\"${CLAUDE_PLUGIN_DIR}/.env/bin/python3\"" >> "${CLAUDE_PLUGIN_DIR}/.env/env.sh"