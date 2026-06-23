#!/bin/bash
set -e

CLAUDE_PLUGIN_DIR=$1
if [[ -z "$CLAUDE_PLUGIN_DIR" ]]; then
    echo "CLAUDE_PLUGIN_DIR not set -- exiting"
    exit 1
fi

if [ ! -d "${CLAUDE_PLUGIN_DIR}/.env" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "${CLAUDE_PLUGIN_DIR}/.env"
fi

echo "Upgrading pip..."
"${CLAUDE_PLUGIN_DIR}/.env/bin/pip" install --upgrade pip

SENTINEL="${CLAUDE_PLUGIN_DIR}/.env/.installed_version"
CURRENT_VERSION=$(python3 -c "import json; print(json.load(open('${CLAUDE_PLUGIN_DIR}/.claude-plugin/plugin.json'))['version'])" 2>/dev/null)

if [ ! -f "$SENTINEL" ] || [ "$(cat "$SENTINEL")" != "$CURRENT_VERSION" ]; then
    echo "Installing agent_shims..."
    "${CLAUDE_PLUGIN_DIR}/.env/bin/pip" install -e "${CLAUDE_PLUGIN_DIR}/agent_shims"
    echo "$CURRENT_VERSION" > "$SENTINEL"
fi

mkdir -p /tmp/scx-plugin/prompts /tmp/scx-plugin/progress

echo "export SCX_PLUGIN_PYTHON=\"${CLAUDE_PLUGIN_DIR}/.env/bin/python3\"" >> "${CLAUDE_PLUGIN_DIR}/.env/env.sh"