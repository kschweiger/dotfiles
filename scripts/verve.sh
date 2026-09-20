#!/usr/bin/env bash

set -e

SESSION="verve"

BACKEND="$HOME/Code/verve/backend"
FRONTEND="$HOME/Code/verve/frontend"
HYDRATION="$HOME/Code/verve/hydration"

open_session() {
  # If we're already inside tmux, switch the current client.
  # Otherwise attach from the normal terminal.
  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$SESSION"
  else
    exec tmux attach-session -t "$SESSION"
  fi
}

# ------------------------------------------------------------
# Existing session
# ------------------------------------------------------------

# Don't recreate windows or restart processes if verve is already running.
if tmux has-session -t "$SESSION" 2>/dev/null; then
  open_session
  exit 0
fi

# ------------------------------------------------------------
# Window 1: Backend
# ------------------------------------------------------------

tmux new-session -d \
  -s "$SESSION" \
  -n backend \
  -c "$BACKEND"

# Keep the shell as the pane process and start nvim inside it.
# This means :q returns to the shell instead of closing the tmux window.
tmux send-keys \
  -t "$SESSION:backend" \
  'nvim .' Enter

# ------------------------------------------------------------
# Window 2: Frontend
# ------------------------------------------------------------

tmux new-window \
  -t "$SESSION" \
  -n frontend \
  -c "$FRONTEND"

tmux send-keys \
  -t "$SESSION:frontend" \
  'nvim .' Enter

# ------------------------------------------------------------
# Window 3: Dev processes
#
#   FastAPI
#   Celery
#   Frontend
#
# Three panes stacked vertically.
# ------------------------------------------------------------

# Pane 1: FastAPI
PANE_FASTAPI=$(tmux new-window \
  -P \
  -F '#{pane_id}' \
  -t "$SESSION" \
  -n dev \
  -c "$BACKEND")

# Pane 2: Celery
PANE_CELERY=$(tmux split-window \
  -P \
  -F '#{pane_id}' \
  -v \
  -t "$PANE_FASTAPI" \
  -c "$BACKEND")

# Pane 3: frontend
PANE_FRONTEND=$(tmux split-window \
  -P \
  -F '#{pane_id}' \
  -v \
  -t "$PANE_CELERY" \
  -c "$FRONTEND")

# Make all three panes equally high.
tmux select-layout \
  -t "$SESSION:dev" \
  even-vertical

# Start the processes inside normal shells.
# If one crashes/exits, the pane stays open and shows the shell prompt.
tmux send-keys \
  -t "$PANE_FASTAPI" \
  'LOG_LEVEL=INFO spin uv run fastapi dev verve_backend/main.py' Enter

tmux send-keys \
  -t "$PANE_CELERY" \
  'uv run celery -A verve_backend.celery_app worker -P gevent --loglevel=info' Enter

tmux send-keys \
  -t "$PANE_FRONTEND" \
  'bun run dev' Enter

# ------------------------------------------------------------
# Window 4: Hydration
# ------------------------------------------------------------

tmux new-window \
  -t "$SESSION" \
  -n hydration \
  -c "$HYDRATION"

tmux send-keys \
  -t "$SESSION:hydration" \
  'nvim .' Enter

# ------------------------------------------------------------
# Start in backend window
# ------------------------------------------------------------

tmux select-window -t "$SESSION:backend"

open_session
