# antergos-pkgs

Custom package repository for Antergos NeXT ISO builds.

## Packages

| Package | Description | Source Branch |
|---------|-------------|---------------|
| `cnchi` | Antergos NeXT graphical installer | `0.16.x` (stable), `cnchi-dev` (development) |
| `antergos-next-keyring` | GPG keyring for the repo |
| `antergos-next-mirrorlist` | Mirror list for `[antergos-pkgs]` |
| `antergos-next-desktop-settings` | Custom GTK/Plasma theme, dconf defaults |
| `antergos-wallpapers` | Antergos desktop wallpapers |
| `yay` | AUR helper |
| `downgrade` | Pacman package downgrade tool |

## Usage

Add to `/etc/pacman.conf`:

```
[antergos-pkgs]
SigLevel = Optional TrustAll
Server = https://Antergos-NeXT.github.io/antergos-pkgs/
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
