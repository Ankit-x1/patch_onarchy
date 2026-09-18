# Patch Onarchy

An ML, robotics, Docker, and agent-work overlay on top of [Omarchy](https://github.com/omacom/omarchy).
This Windows checkout is for editing and pushing; the desktop overlay runs on Linux.

## What this adds

| Layer | Location | Purpose |
| --- | --- | --- |
| Packages | `patch/packages.txt` | CUDA tools, Docker, Python, and robotics dependencies |
| Theme | `themes/patch-onarchy/` | Patch Onarchy color and application theme |
| Hyprland | `config/hypr/bindings.lua` | Workspace roles for code, monitoring, and training |
| GPU widget | `patch/plugins/ankit.gpu/` | NVIDIA utilization and VRAM in the bar |
| Python environments | `~/.venvs/` | `axon` and `robotics` environments |

## Install on Omarchy Linux

Install Omarchy from the official [Omarchy ISO](https://iso.omarchy.org/) first, then:

```bash
git clone git@github.com:Ankit-x1/patch_onarchy.git ~/Projects/patch_onarchy
cd ~/Projects/patch_onarchy
git checkout ankit-dev

omarchy-dev-link ~/Projects/patch_onarchy
bash ~/Projects/patch_onarchy/patch/apply.sh
```

After editing the linked checkout, refresh the affected config:

```bash
omarchy-refresh-config hypr/bindings.lua
hyprctl reload
```

## Python environments

The installer creates these environments and does not install CUDA wheels automatically:

```bash
source ~/.venvs/axon/bin/activate       # FastAPI, JupyterLab, Qdrant client
source ~/.venvs/robotics/bin/activate   # NumPy, SciPy, ONNX
```

Install a PyTorch wheel that matches the NVIDIA driver on the Linux machine.

## Pull upstream changes

```bash
git fetch upstream
git rebase upstream/quattro
git push origin ankit-dev --force-with-lease
```

Validate the installer before committing:

```bash
bash -n patch/apply.sh
```
