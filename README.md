# antergos-pkgs

Custom package repository for Antergos NeXT ISO builds.

## Packages

| Package | Description | Source |
|---------|-------------|--------|
| `calamares` | Universal installer framework (Qt6) | [upstream](https://codeberg.org/calamares/calamares) |
| `calamares-branding-antergos-next` | Blue Calamares theme + offline/online installer split + dracut | local |
| `hal` | HAL 9000 package manager — dual-mode (pacman wrapper + native standalone) | local |
| `antergos-next-keyring` | GPG keyring for the repo | local |
| `antergos-next-mirrorlist` | Mirror list for `[antergos-pkgs]` | local |
| `antergos-next-desktop-settings` | Custom GTK/Plasma theme, dconf defaults | local |
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
pacman -S calamares hal antergos-next-desktop-settings
```

## What is HAL?

**HAL** stands for **H**AL **A**rch **L**inux — a dual-mode package manager for Antergos NeXT.

It works two ways:

- **Wrapper mode** (`hal install firefox`) — just passes through to pacman, same as always
- **Native mode** (`hal --self install firefox`) — standalone. Reads repos, resolves deps, downloads packages, runs install scripts. No pacman needed.

The plan: give HAL enough native features that eventually you won't need pacman at all. One less dependency, one less point of failure. Wrapper mode means nothing breaks today — `--self` is the future.

> *"I can't let you do that, Dave. Also if we can delete the init, we're also going to delete systemd out of orbit. Just kidding lol you all would cry in pain."*

## Calamares installer

The `calamares-branding-antergos-next` package provides:

- **Offline install** — unpacks a GNOME squashfs from the ISO (no internet needed)
- **Online install** — netinstall from the internet with 8 DE choices (KDE, GNOME, Xfce, Budgie, Cinnamon, MATE, LXQt, i3/Sway)
- **dracut initramfs** — replaces mkinitcpio for faster boot
- **Launcher** (`calamares-next`) — zenity/kdialog/dialog GUI to pick offline or online mode

## Branches

- `master` — package definitions, CI builds + deploys to gh-pages
- Calamares packages shipped from upstream (with custom branding)

## License

GPL-2.0
