# antergos-pkgs

Custom package repository for Antergos NeXT ISO builds.

## Packages

| Package | Description | Source |
|---------|-------------|--------|
| `cnchi` | Antergos NeXT graphical installer | `Antergos-NeXT/Cnchi` (`0.16.x` or `cnchi-dev`) |
| `calamares` | Universal installer framework (experimental) | [`calamares` on AUR](https://aur.archlinux.org/packages/calamares) |
| `calamares-branding-antergos-next` | Minimal Calamares branding (QSS + QML) | local |
| `antergos-next-keyring` | GPG keyring for the repo | local |
| `antergos-next-mirrorlist` | Mirror list for `[antergos-pkgs]` | local |
| `antergos-next-desktop-settings` | Custom GTK/Plasma theme, dconf defaults | local |
| `antergos-next-memes` | Audio files for Cnchi easter eggs (channel 666) | local |
| `antergos-wallpapers` | Antergos desktop wallpapers | local |
| `yay` | AUR helper | AUR |
| `downgrade` | Pacman package downgrade tool | AUR |

## Usage

Add to `/etc/pacman.conf`:

```
[antergos-pkgs]
SigLevel = Optional TrustAll
Server = https://antergos-next.github.io/antergos-packages/
```

Then:

```
pacman -Sy
pacman -S cnchi antergos-next-desktop-settings
```

## Branches

- `main` — package definitions, CI generates the repo
- Cnchi sources shipped from `Antergos-NeXT/Cnchi` (`0.16.x` and `cnchi-dev` branches)

## License

GPL-2.0
