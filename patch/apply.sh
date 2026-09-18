#!/bin/bash
# Install Patch Onarchy extras on a running Omarchy (Quattro) machine.
# Run this from the git checkout on Linux. Do not run on Windows.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PATCH_DIR="$ROOT/patch"

log() { echo "[patch-onarchy] $*"; }
warn() { echo "[patch-onarchy] WARNING: $*" >&2; }
die() { echo "[patch-onarchy] ERROR: $*" >&2; exit 1; }

[[ $(uname -s) == "Linux" ]] || die "Run this on your Omarchy Linux machine, not Windows."
command -v omarchy-pkg-add >/dev/null || die "omarchy-pkg-add not found. Install Omarchy from the official ISO first."

log "Installing packages from patch/packages.txt"
mapfile -t packages < <(grep -vE '^\s*(#|$)' "$PATCH_DIR/packages.txt")
if (( ${#packages[@]} > 0 )); then
  omarchy-pkg-add "${packages[@]}"
else
  warn "No packages found in $PATCH_DIR/packages.txt"
fi

setup_venv() {
  local name="$1"
  shift
  local venv="$HOME/.venvs/$name"

  mkdir -p "$HOME/.venvs"
  if [[ ! -d "$venv" ]]; then
    python -m venv "$venv"
  fi
  "$venv/bin/python" -m pip install --upgrade pip
  if (( $# > 0 )); then
    "$venv/bin/python" -m pip install "$@"
  fi
  log "Python environment ready: $venv"
}

log "Setting up Python environments"
setup_venv axon fastapi uvicorn httpx jupyterlab qdrant-client redis
setup_venv robotics numpy scipy onnx onnxruntime pydantic
log "Install CUDA-enabled PyTorch separately to match the installed driver."

log "Installing Patch Onarchy theme"
mkdir -p "$HOME/.config/omarchy/themes"
ln -sfn "$ROOT/themes/patch-onarchy" "$HOME/.config/omarchy/themes/patch-onarchy"
if command -v omarchy-theme-set >/dev/null; then
  omarchy-theme-set patch-onarchy || warn "Could not activate patch-onarchy automatically."
fi

log "Installing GPU bar plugin"
mkdir -p "$HOME/.config/omarchy/plugins"
ln -sfn "$PATCH_DIR/plugins/ankit.gpu" "$HOME/.config/omarchy/plugins/ankit.gpu"
if omarchy plugin validate "$PATCH_DIR/plugins/ankit.gpu"; then
  omarchy plugin enable ankit.gpu || warn "Could not enable ankit.gpu automatically."
else
  warn "GPU plugin validation failed; leaving it installed but disabled."
fi

log "Refreshing Hyprland bindings"
omarchy-refresh-config hypr/bindings.lua || warn "Could not refresh Hyprland bindings."
if command -v hyprctl >/dev/null; then
  hyprctl reload || warn "Could not reload Hyprland."
fi

if command -v nvidia-smi >/dev/null; then
  nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader || warn "nvidia-smi could not query the GPU."
else
  warn "nvidia-smi not found; the GPU widget will remain unavailable until NVIDIA drivers are installed."
fi

if command -v docker >/dev/null; then
  if docker info >/dev/null 2>&1; then
    log "Docker daemon is running."
  else
    warn "Docker is installed but the daemon is not running."
  fi
fi

log "Done. Activate environments with: source ~/.venvs/axon/bin/activate"
log "Workspaces: 1 code, 2 terminal, 3 monitor, 4 browser, 5 training"
