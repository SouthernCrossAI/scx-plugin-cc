---
name: setup
description: Initialize the plugin environment. Run this once after installing the plugin to set up the virtual environment and install agent_shims. After this, /code is ready to use.
allowed-tools: Bash(bash *)
---

# Setup

Initializes the plugin environment so `/code` is ready to use.

## Instructions

Run: `bash ${CLAUDE_PLUGIN_ROOT}/hooks/setup.sh ${CLAUDE_PLUGIN_ROOT}`

Report success or any errors to the user.