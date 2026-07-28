# antergos-packages

Custom package repository for Antergos NeXT ISO builds.

## Packages

| Package | Description |
|---------|-------------|
| `calamares` | Universal installer framework (Qt6) — [upstream](https://codeberg.org/calamares/calamares) |
| `calamares-branding-antergos-next` | Antergos Calamares branding + netinstall-based installer + launcher |
| `calamares-branding-antergos-next-minimal` | Themed CMake module for first-run branding (no slideshow) |
| `antergos-next-keyring` | GPG keyring for the `[antergos-pkgs]` repo |
| `antergos-next-mirrorlist` | Mirror list for `[antergos-pkgs]` |
| `antergos-release` | Antergos NeXT `/etc/os-release` |
| `antergos-lsb-release` | LSB release info |
| `antergos-next-desktop-settings` | Plasma/GTK theme, dconf/plasma-settings defaults |
| `antergos-plasma-theme` | Plasma desktop theme |
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

A `calamares-branding-antergos-next-minimal` variant is also provided for the first-run welcome screen (no slideshow, CMake-themable).

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
