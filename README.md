# antergos-pkgs

Custom package repository for Antergos NeXT ISO builds.

## Packages

| Package | Description | Source |
|---------|-------------|--------|
| `calamares` | Universal installer framework (Qt6) | [upstream](https://codeberg.org/calamares/calamares) |
| `calamares-branding-antergos-next` | Antergos Calamares branding + offline/online installer split + launcher | local |
| `antergos-next-keyring` | GPG keyring for the repo | local |
| `antergos-next-mirrorlist` | Mirror list for `[antergos-pkgs]` | local |
| `antergos-next-desktop-settings` | Plasma/GTK theme, dconf defaults | local |
| `antergos-wallpapers` | Antergos desktop wallpapers | local |
| `antergos-grub-theme` | Antergos GRUB theme | local |
| `antergos-welcome` | Welcome screen + support tool | local |
| `antergos-live` | Live session configuration | local |
| `antergos-release` | Antergos NeXT release file | local |
| `antergos-next-memes` | Welcome audio memes | local |
| `yay` | AUR helper | [AUR](https://aur.archlinux.org/packages/yay) |
| `downgrade` | Pacman package downgrade tool | [AUR](https://aur.archlinux.org/packages/downgrade) |

## Usage

Add to `/etc/pacman.conf`:

```
[antergos-pkgs]
SigLevel = Optional TrustAll
Server = https://antergos-next.github.io/antergos-packages/$repo/os/$arch
```

Then:

```
pacman -Sy
pacman -S calamares calamares-branding-antergos-next antergos-wallpapers
```

## Calamares installer

The `calamares-branding-antergos-next` package provides:

- **Offline install** — unpacks KDE Plasma squashfs from the ISO (no internet needed)
- **Online install** — netinstall with init system selection (OpenRC, Dinit, S6, Runit)
- **Launcher** (`calamares-next`) — mode picker (online/offline) before launching Calamares
- **Packagechooser** — init system selection during online install

## Branches

- `master` — package definitions, CI builds + deploys to gh-pages
- Calamares packages shipped from upstream (with custom branding)

## Index

The repository index at [antergos-next.github.io/antergos-packages](https://antergos-next.github.io/antergos-packages/) is auto-generated via `generate-index.py` — parses PKGBUILD metadata and built packages to produce a sortable, searchable package browser.

## License

GPL-3.0
