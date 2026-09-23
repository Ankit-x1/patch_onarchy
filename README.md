# Patch Onarchy

Patch Onarchy is an Omarchy Quattro overlay for ML, robotics, Docker, and agent development. It keeps the upstream Omarchy desktop and adds a focused package set, theme, workspace roles, and an NVIDIA GPU bar widget.

This repository is a source overlay, not a standalone ISO distribution. Install Omarchy from the official [Omarchy ISO](https://iso.omarchy.org/) first, then apply this project on the Linux machine.

## Quick start

```bash
git clone git@github.com:Ankit-x1/patch_onarchy.git ~/Projects/patch_onarchy
cd ~/Projects/patch_onarchy
git switch main
omarchy-dev-link ~/Projects/patch_onarchy
bash patch/apply.sh
```

The Windows checkout is suitable for editing and pushing. The installer and Quickshell widget run on Omarchy Linux only.

## Included

- ML and robotics packages in `patch/packages.txt`
- `axon` and `robotics` Python environments under `~/.venvs/`
- Patch Onarchy theme in `themes/patch-onarchy/`
- Hyprland workspace roles in `config/hypr/bindings.lua`
- NVIDIA utilization and VRAM widget in `patch/plugins/ankit.gpu/`

Detailed setup and maintenance instructions are in [patch/README.md](patch/README.md).

## Validation

Run these checks before publishing changes:

```bash
bash -n patch/apply.sh
omarchy plugin validate patch/plugins/ankit.gpu
```

The complete runtime check must be performed on the Omarchy Linux machine with `nvidia-smi`, the Quickshell bar, and the installed hardware available.

## Upstream

This project tracks [Omarchy](https://github.com/omacom/omarchy) through the `upstream` remote. Pull upstream Quattro changes into a clean working tree with:

```bash
git fetch upstream
git rebase upstream/quattro
git push origin main --force-with-lease
```

## License

The underlying Omarchy project is released under the [MIT License](https://opensource.org/licenses/MIT). Patch Onarchy changes are published in this repository under the same license.
