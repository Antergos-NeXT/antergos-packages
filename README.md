# Antergos‑NeXT Packages Repository — Migration Notice

This repository will be archived after the project completes its migration to our self‑hosted Gitea forge.  
Package build scripts, metadata, and updates now continue on Gitea, aligned with upstream Artix workflows.

Active development is located at:

https://antergos-nas.taild4360b.ts.net/Antergos-NeXT/antergos-packages

After migration, GitHub will remain available only as a fallback issue tracker for users who prefer GitHub.  
All package development and updates now occur exclusively on the Gitea platform. 

Custom package repository for Antergos NeXT ISO builds.

## Packages

| Package | Description |
|---------|-------------|
| `calamares` | Universal installer framework (Qt6) — [upstream](https://codeberg.org/calamares/calamares) |
| `calamares-branding-antergos-next` | Antergos Calamares branding + netinstall-based installer + launcher |
| `antergos-next-keyring` | GPG keyring for the `[antergos-pkgs]` repo |
| `antergos-next-mirrorlist` | Mirror list for `[antergos-pkgs]` |
| `antergos-release` | Antergos NeXT `/etc/os-release` |
| `antergos-lsb-release` | LSB release info |
| `antergos-next-desktop-settings` | Plasma/GTK theme, dconf/plasma-settings defaults |
| `antergos-xfce-theme` | XFCE desktop theme |
| `antergos-layan-theme` | Layan theme variant |
| `antergos-wallpapers` | Desktop wallpapers |
| `antergos-grub-theme` | GRUB theme |
| `antergos-welcome` | Welcome screen + support tool |
| `antergos-live` | Live session configuration |
| `antergos-i3-config` | Dark Antergos i3 configuration |
| `antergos-sway-config` | Dark Antergos Sway configuration |
| `antergos-hyprland-config` | Dark Antergos Hyprland configuration (Lua) |
| `pixie-sddm-git` | SDDM theme (pixie) |
| `tela-circle-icon-theme-git` | Tela Circle icon theme |
| `kwin-zones` | KWin tiling zones |
| `oh-my-posh-bin` | Prompt theme engine |
| `pacseek` | Pacman TUI browser |
| `yay` | AUR helper — [AUR](https://aur.archlinux.org/packages/yay) |
| `downgrade` | Pacman package downgrade tool — [AUR](https://aur.archlinux.org/packages/downgrade) |

## Usage

Add to `/etc/pacman.conf` (before `[system]` to take priority):

```ini
[antergos-pkgs]
SigLevel = Optional TrustAll
Server = https://antergos-next.github.io/antergos-packages/
```

Then:

```sh
pacman -Sy
pacman -S calamares calamares-branding-antergos-next antergos-wallpapers
```

## Calamares installer

`calamares-branding-antergos-next` is the main branding component with:

- **Packagechooser + netinstall** — DE selector (KDE, GNOME, XFCE, i3, Sway, Hyprland, Budgie, Cinnamon, MATE) and DM selector (SDDM, LightDM, GDM, Ly, greetd), with basestrap-based package groups
- **Launcher** (`calamares-next`) — launches Calamares with online settings
- **Animated space slideshow** — rocket, stars, comet, moon with smooth 700ms transitions

## How it works

On each push to `master` (or weekly Monday), GitHub Actions:

1. Builds all packages from `packages.yaml` inside an Artix Linux container
2. Creates a pacman repo database (`repo-add`)
3. Generates a browsable package index (`generate-index.py`)
4. Deploys to [gh-pages](https://antergos-next.github.io/antergos-packages/)

The repo serves as both a pacman repository and a web-based package browser.

## Contributing

See [CONTRIBUTING.md](https://github.com/Antergos-NeXT/antergos-packages/blob/master/CONTRIBUTING.md).

## License

GPL-3.0
