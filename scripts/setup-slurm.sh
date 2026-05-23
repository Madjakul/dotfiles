#!/usr/bin/env bash
# scripts/setup-slurm.sh
# Bootstrap a fresh SLURM compute server with Miniconda, cache dirs, and CLI tools.
# Designed for /lustre or /scratch work directories where $HOME has limited quota.
#
# Usage:
#   bash setup-slurm.sh                  # auto-detect WORK_DIR
#   WORK_DIR=/scratch/$USER bash setup-slurm.sh  # specify WORK_DIR
#
# What it does:
#   1. Cleans any existing conda/cache from $HOME and $WORK_DIR
#   2. Installs Miniconda to $WORK_DIR
#   3. Configures conda package/env dirs on work filesystem
#   4. Sets up HuggingFace, PyTorch, pip, and Ray cache dirs
#   5. Installs a "cli" environment with useful tools (ipython, gpustat, etc.)
#   6. Appends env vars to ~/.bashrc

set -euo pipefail

# ====== Detect work directory ======
# Try common SLURM work dir patterns if WORK_DIR not set
if [[ -z "${WORK_DIR:-}" ]]; then
    for candidate in \
        "/lustre/work/grandchallenge1/$USER" \
        "/lustre/fswork/$USER" \
        "/scratch/$USER" \
        "/work/$USER"; do
        if [[ -d "$(dirname "$candidate")" ]]; then
            WORK_DIR="$candidate"
            break
        fi
    done
fi

if [[ -z "${WORK_DIR:-}" ]]; then
    echo "ERROR: Could not detect WORK_DIR. Set it manually:"
    echo "  WORK_DIR=/path/to/work bash setup-slurm.sh"
    exit 1
fi

echo "=== SLURM Server Setup ==="
echo "WORK_DIR: $WORK_DIR"
echo "USER:     $USER"
echo

read -p "This will WIPE existing conda/caches in $WORK_DIR. Continue? [y/N] " -n 1 -r
echo
[[ $REPLY =~ ^[Yy]$ ]] || exit 0

# ====== 1. Clean existing installations ======
echo "--- Cleaning old installations ---"
cd ~
rm -rf miniconda3 .conda .condarc .cache/pip .cache/huggingface .local/share/pip 2>/dev/null || true

mkdir -p "$WORK_DIR"
cd "$WORK_DIR"
rm -rf miniconda3 conda pip_cache hf_cache torch_cache ray_cache 2>/dev/null || true

# ====== 2. Install Miniconda ======
echo "--- Installing Miniconda ---"
cd "$WORK_DIR"
wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p "$WORK_DIR/miniconda3"
rm miniconda.sh

# Initialize conda for bash
"$WORK_DIR/miniconda3/bin/conda" init bash

# ====== 3. Configure conda ======
echo "--- Configuring conda ---"
cat > ~/.condarc << EOF
pkgs_dirs:
  - $WORK_DIR/conda/pkgs
envs_dirs:
  - $WORK_DIR/conda/envs
auto_activate_base: false
channel_priority: strict
EOF

# ====== 4. Set up environment variables ======
echo "--- Adding environment variables to ~/.bashrc ---"

# Remove any previous block we wrote
sed -i '/# === Dotfiles SLURM Config ===/,/# === End Dotfiles SLURM Config ===/d' ~/.bashrc

cat >> ~/.bashrc << EOF

# === Dotfiles SLURM Config ===
export WORK_DIR=$WORK_DIR

# Conda
export CONDA_PKGS_DIRS=\$WORK_DIR/conda/pkgs

# Pip
export PIP_CACHE_DIR=\$WORK_DIR/pip_cache

# HuggingFace
export HF_HOME=\$WORK_DIR/hf_cache
export HUGGINGFACE_HUB_CACHE=\$WORK_DIR/hf_cache/hub
export TRANSFORMERS_CACHE=\$WORK_DIR/hf_cache/transformers
export HF_DATASETS_CACHE=\$WORK_DIR/hf_cache/datasets

# PyTorch
export TORCH_HOME=\$WORK_DIR/torch_cache

# Ray (distributed training)
export RAY_TMPDIR=\$WORK_DIR/ray_cache

# Aliases
alias cli="conda activate cli"
# === End Dotfiles SLURM Config ===
EOF

# ====== 5. Create cache directories ======
echo "--- Creating cache directories ---"
mkdir -p "$WORK_DIR"/{conda/pkgs,conda/envs,pip_cache,hf_cache,torch_cache,ray_cache}

# ====== 6. Reload and create CLI environment ======
echo "--- Creating CLI environment ---"
source ~/.bashrc
"$WORK_DIR/miniconda3/bin/conda" create -n cli python=3.11 -y

# Install CLI tools (pure Python, no compilation)
"$WORK_DIR/miniconda3/bin/conda" run -n cli pip install \
    ipython \
    rich \
    huggingface_hub[cli] \
    gpustat

# ====== 7. Verify ======
echo
echo "=== Verification ==="
"$WORK_DIR/miniconda3/bin/conda" info
echo "WORK_DIR:  $WORK_DIR"
echo "HF_HOME:   $WORK_DIR/hf_cache"
echo "TORCH_HOME: $WORK_DIR/torch_cache"
"$WORK_DIR/miniconda3/bin/conda" run -n cli python -c "import rich; print('✓ Rich installed')"
"$WORK_DIR/miniconda3/bin/conda" run -n cli python -c "import IPython; print(f'✓ IPython {IPython.__version__}')"
echo
echo "=== Done! Run 'source ~/.bashrc && conda activate cli' ==="
