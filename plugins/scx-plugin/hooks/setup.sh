CLAUDE_PLUGIN_DIR=$1

if [[ -z "$CLAUDE_PLUGIN_DIR" ]]; then
  echo "CLAUDE_PLUGIN_DIR not set -- exiting"
  exit 1
fi

# Find a Python >= 3.11 with working ensurepip (required by agent_shims).
PYTHON3=python3
for _py in "$HOME/.pyenv/shims/python3" python3.13 python3.12 python3.11; do
  if command -v "$_py" &>/dev/null \
     && "$_py" -c 'import sys; exit(0 if sys.version_info >= (3,11) else 1)' 2>/dev/null \
     && "$_py" -m ensurepip --version &>/dev/null; then
    PYTHON3="$_py"; break
  fi
done

if [ ! -d "${CLAUDE_PLUGIN_DIR}/.env" ]; then
  echo "Creating virtual environment..."
  $PYTHON3 -m venv "${CLAUDE_PLUGIN_DIR}/.env"
fi

SENTINEL="${CLAUDE_PLUGIN_DIR}/.env/.installed_version"
CURRENT_VERSION=$($PYTHON3 -c "import json; print(json.load(open('${CLAUDE_PLUGIN_DIR}/.claude-plugin/plugin.json'))['version'])" 2>/dev/null)

if [ ! -f "$SENTINEL" ] || [ "$(cat "$SENTINEL")" != "$CURRENT_VERSION" ]; then
  "${CLAUDE_PLUGIN_DIR}/.env/bin/pip" install --upgrade pip -q
  "${CLAUDE_PLUGIN_DIR}/.env/bin/pip" install -e "${CLAUDE_PLUGIN_DIR}/agent_shims"
  echo "$CURRENT_VERSION" > "$SENTINEL"
fi

mkdir -p /tmp/scx-plugin/prompts /tmp/scx-plugin/progress

ENV_LINE="export SCX_PLUGIN_PYTHON=\"${CLAUDE_PLUGIN_DIR}/.env/bin/python3\""
echo "$ENV_LINE" > "${CLAUDE_PLUGIN_DIR}/.env/env.sh"
if [[ -n "$CLAUDE_ENV_FILE" ]]; then
  echo "$ENV_LINE" >> "$CLAUDE_ENV_FILE"
fi
