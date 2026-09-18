# Patch Onarchy

Your Omarchy Quattro fork: Arch + Hyprland + Quickshell, tuned for ML, robotics, Docker, and agent work.

This Windows checkout is only for editing and pushing. The desktop itself runs on Linux.

## What changed vs stock Omarchy

Quattro is package-based. The old `OMARCHY_REF=... curl boot.sh` install does **not** work on v4. Official installs use the [Omarchy ISO](https://iso.omarchy.org/). This repo is the **source overlay**: extra packages, a theme, Hyprland workspace roles, and a GPU bar plugin.

## On the Linux machine (once)

1. Install Omarchy from the official ISO and finish first boot.
2. Clone this repo (not into `$HOME` random folders if you want it elsewhere):

```bash
git clone git@github.com:Ankit-x1/patch_onarchy.git ~/Projects/patch_onarchy
cd ~/Projects/patch_onarchy
git checkout ankit-dev
```

3. Point Omarchy at this checkout, then reboot:

```bash
omarchy-dev-link ~/Projects/patch_onarchy
```

4. Apply the Patch Onarchy extras:

```bash
bash ~/Projects/patch_onarchy/patch/apply.sh
```

5. After that, edit files here and reload:

```bash
omarchy-refresh-config hypr/bindings.lua
hyprctl reload
```

## What to customize next

| Layer | Where | Do this |
| --- | --- | --- |
| Packages | `patch/packages.txt` | Add CUDA-adjacent tools; keep PyTorch/JAX in `~/.venvs/axon` |
| Theme | `themes/patch-onarchy/` | Tweak `colors.toml` (24-color palette drives terminal, nvim, btop, bar) |
| Hyprland | `config/hypr/bindings.lua` | Workspace roles and window rules |
| Bar widgets | `patch/plugins/` | GPU is `ankit.gpu`; clone more with `omarchy plugin clone` |
| Agents | built-in `omarchy.agents` | Already on the bar for Claude/Codex usage |

Pull upstream later:

```bash
git fetch upstream
git rebase upstream/quattro
git push origin ankit-dev --force-with-lease
```
