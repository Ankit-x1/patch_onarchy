#!/bin/bash
# Install Patch Onarchy extras on a running Omarchy (Quattro) machine.
# Run this from the git checkout on Linux. Do not run on Windows.

set -euo pipefail

if [[ $(uname -s) != "Linux" ]]; then
  echo "Run this on your Omarchy Linux machine, not Windows." >&2
  exit 1
fi

if ! command -v omarchy-pkg-add >/dev/null; then
  echo "omarchy-pkg-add not found. Install Omarchy from the official ISO first." >&2
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> Extra packages"
mapfile -t packages < <(grep -vE '^\s*(#|$)' "$ROOT/patch/packages.txt")
omarchy-pkg-add "${packages[@]}"

echo "==> Python ML venv (torch/jax/fastapi stay in the venv, not system Python)"
mkdir -p "$HOME/.venvs"
if [[ ! -d $HOME/.venvs/axon ]]; then
  python -m venv "$HOME/.venvs/axon"
fi
# shellcheck disable=SC1091
source "$HOME/.venvs/axon/bin/activate"
python -m pip install --upgrade pip
python -m pip install fastapi uvicorn jupyterlab
echo "Activate later with: source ~/.venvs/axon/bin/activate"
echo "Then install CUDA wheels to match your driver, e.g.:"
echo "  pip install torch --index-url https://download.pytorch.org/whl/cu128"

echo "==> Theme"
mkdir -p "$HOME/.config/omarchy/themes"
ln -sfn "$ROOT/themes/patch-onarchy" "$HOME/.config/omarchy/themes/patch-onarchy"
omarchy-theme-set patch-onarchy || true

echo "==> GPU bar plugin"
mkdir -p "$HOME/.config/omarchy/plugins"
ln -sfn "$ROOT/patch/plugins/ankit.gpu" "$HOME/.config/omarchy/plugins/ankit.gpu"
omarchy plugin validate "$ROOT/patch/plugins/ankit.gpu" || true
omarchy plugin enable ankit.gpu || true

echo "==> Deploy Hyprland personal bindings from this checkout"
omarchy-refresh-config hypr/bindings.lua || true
hyprctl reload || true

echo "==> Done. Reboot if you just ran: omarchy-dev-link"
echo "Workspaces: 1 code, 2 terminal, 3 monitor, 4 browser, 5 training"
