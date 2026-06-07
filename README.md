# antergos-pkgs

AUR package repository for Antergos NeXT ISO builds.

## Packages

| Package | Description |
|---------|-------------|
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
pacman -S antergos-wallpapers yay
```

## License

GPL-2.0
