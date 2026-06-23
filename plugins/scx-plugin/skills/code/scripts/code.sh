SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -z "$SCX_PLUGIN_PYTHON" ]]; then
  ENV_SH="${SCRIPT_DIR}/../../../.env/env.sh"
  [[ -f "$ENV_SH" ]] && source "$ENV_SH"
fi

${SCX_PLUGIN_PYTHON} "${SCRIPT_DIR}/code.py" "$@"
