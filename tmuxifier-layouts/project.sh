#!/bin/sh
# tmuxifier-layouts/project.sh
# Default project layout for SSHFS-mounted research projects.
#
# Usage:
#   tmuxifier load-session project         # uses defaults
#   PROJECT=DeepStylometry tmuxifier load-session project  # override name
#
# What it does:
#   Window 1 "Dev": 75/25 split
#     Left (75%)  → conda activate $session, cd mount, nvim
#     Top-right   → conda activate $session, cd mount (spare terminal)
#     Bot-right   → cd mount, lazygit
#   Window 2 "Monitor": spare tab for SSH/SLURM monitoring
#
# Configuration: set these env vars or edit the defaults below.
# REMOTE_SERVER   — e.g. user@cleps.inria.fr
# REMOTE_PATH     — e.g. /home/user/scratch/ProjectName
# LOCAL_MOUNT     — e.g. ~/Documents/ProjectName

# ── Defaults (override with env vars or per-project copies) ──
session_name="${PROJECT:-$(basename "$0" .sh)}"
REMOTE_SERVER="${REMOTE_SERVER:-}"
REMOTE_PATH="${REMOTE_PATH:-}"
LOCAL_MOUNT="${LOCAL_MOUNT:-$HOME/Documents/$session_name}"

# ── SSHFS Mount ──
if [[ -n "$REMOTE_SERVER" && -n "$REMOTE_PATH" ]]; then
    mkdir -p "$LOCAL_MOUNT"
    if ! mount | grep -q "$LOCAL_MOUNT"; then
        echo "Mounting $REMOTE_SERVER:$REMOTE_PATH → $LOCAL_MOUNT"
        sshfs "$REMOTE_SERVER:$REMOTE_PATH" "$LOCAL_MOUNT" \
            -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 \
            -o cache=yes,kernel_cache,compression=no
    else
        echo "Already mounted: $LOCAL_MOUNT"
    fi
fi

# ── Conda: create env if it doesn't exist ──
if command -v conda &>/dev/null; then
    if ! conda env list | grep -q "^${session_name} "; then
        echo "Creating conda env: $session_name"
        conda create -n "$session_name" python=3.11 -y
    fi
fi

# ── Tmuxifier session layout ──
if initialize_session "$session_name"; then

    # Window 1: Dev Environment (75% left / 25% right)
    new_window "Dev"
    split_h 25

    # Left pane (0): Neovim in the project directory
    select_pane 0
    run_cmd "conda activate $session_name"
    run_cmd "cd $LOCAL_MOUNT && nvim"

    # Right side: split vertically 50/50
    select_pane 1
    split_v 50

    # Top-right pane (1): spare terminal
    select_pane 1
    run_cmd "conda activate $session_name"
    run_cmd "cd $LOCAL_MOUNT"

    # Bottom-right pane (2): lazygit
    select_pane 2
    run_cmd "cd $LOCAL_MOUNT"
    run_cmd "lazygit"

    # Window 2: Monitor (SSH, SLURM, etc.)
    new_window "Monitor"
    run_cmd "cd $LOCAL_MOUNT"

    # Focus on the editor
    select_window 0
    select_pane 0

fi

finalize_and_go_to_session
