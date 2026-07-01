CLAUDE_PLUGIN_DIR=$1
if [[ -z "$CLAUDE_PLUGIN_DIR" ]]; then
    echo "CLAUDE_PLUGIN_DIR not set -- exiting"
    exit 1
fi

# Warm the venv eagerly at session start so the first MCP connect doesn't pay
# the create/install cost (and risk the MCP startup timeout). This shares a
# lock with the MCP bootstrap wrapper, so the two never clobber each other.
"${CLAUDE_PLUGIN_DIR}/hooks/ensure_venv.sh" "$CLAUDE_PLUGIN_DIR"

echo "export SCX_PLUGIN_PYTHON=\"${CLAUDE_PLUGIN_DIR}/.env/bin/python3\"" >> "$CLAUDE_ENV_FILE"
echo "export SCX_PLUGIN_MCP_SERVER=\"${CLAUDE_PLUGIN_DIR}/mcp_server/server.py\"" >> "$CLAUDE_ENV_FILE"
