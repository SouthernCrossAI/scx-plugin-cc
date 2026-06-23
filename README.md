# Skills

Claude Code skills for running coding sub-agents with MiniMax-M2.7 via opencode.

## Installation

### Step 1: Add the marketplace

In Claude Code, run:

```
/plugin marketplace add <this repository link>
```

### Step 2: Install the plugin

```
/plugin install scx-plugin
```

## Prerequisites

- Python 3 with `venv` support
- A `SCX_API_KEY` environment variable (required by `/code`)
- `opencode` installed (CLI available — no model configuration required)
- Run `/setup` once after installing the plugin

## Skills Overview

| Skill | Command | Description |
|---|---|---|
| [setup](#setup) | `/setup` | Initialize the plugin environment (run once after install) |
| [code](#code) | `/code <cwd> <prompt> [--max-tokens <n>] [--tool-arg <arg>...]` | Delegate a coding task to a sub-agent using opencode + MiniMax-M2.7 |

## Skill Details

### setup

Run once after installing the plugin. Creates the virtual environment and installs `agent_shims`.

```
/setup
```

After this, `/code` is ready to use.

### code

Runs opencode as a sub-agent with MiniMax-M2.7. Useful for delegating tasks like
code review, implementation, or ideation.

```
/code <cwd> <prompt> [--max-tokens <n>] [--tool-arg <arg>...]
```

**Arguments:**

| Argument | Required | Description |
|---|---|---|
| `cwd` | Yes | Working directory for the tool (defaults to project root if unspecified) |
| `prompt` | Yes | The prompt to send, quoted as a single shell argument |
| `--max-tokens` | No | Override the model's `max_completion_tokens` for this run |
| `--tool-arg` | No | Extra args passed to opencode (repeatable, use `=` syntax for flags: `--tool-arg="--file"`) |

**Examples:**

```bash
# Basic usage
/code /project "review this code"

# Override max tokens
/code /project "implement feature X" --max-tokens 32000

# Attach files
/code /project "analyze these files" --tool-arg="-f" --tool-arg="src/main.py"
```

## Architecture

```
skills/
├── setup/                  # Environment initialization (run once)
└── code/                   # Sub-agent coding tool runner (opencode + MiniMax-M2.7)

agent_shims/                # Shared Python package (installed by /setup)
├── model.py                # Model dataclass
├── model_parameters/       # SQLite-backed model parameter storage
├── cn/                     # Continue runner
└── opencode/               # Opencode runner
```

Each skill follows the same pattern:
1. `SKILL.md` — metadata and instructions for Claude Code
3. `scripts/*.py` — implementation using `agent_shims`