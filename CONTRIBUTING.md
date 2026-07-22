# Contributing to Antergos NeXT Packages

## Who's behind this

This project is maintained **solo** by Michał (c-ludenberg). I'm recovering from an ankle injury, so updates may be slow. Contributions are genuinely appreciated — they keep the project moving when I can't.

## How to contribute

### Issues

- **Bug reports**: Include the package name, version (`pacman -Q <pkg>`), and steps to reproduce. Paste relevant log output.
- **Feature requests**: Explain what package or change you want and why. PRs are better than requests.
- **Questions**: If it's about using the ISO, check the [antergos-iso docs](https://antergos-next.github.io/antergos-iso/) first. If it's about packaging, just open an issue.

### Pull requests

1. Fork the repo, create a branch from `master`.
2. Place your PKGBUILD at `packages/<pkgname>/PKGBUILD` with any needed supporting files (patches, install scripts, config files).
3. Make your changes. Keep commits small and signed (`git commit -S`).
4. Test your package with `makepkg -si` in the package directory.
5. Open a PR with a clear description of what and why.

### Before committing

This repo requires **GPG-signed commits**. Set up your key:

```bash
git config user.signingkey <your-key>
git config commit.gpgsign true
```

## Package conventions

- `pkgname` matches the directory name (lowercase, hyphen-separated).
- `pkgrel` starts at `1` and increments per change.
- Antergos-specific packages use the `antergos-` prefix.
- Config files that need specific paths can use a `Configs/` directory mirroring the filesystem layout.

## Key gotchas

- **Init system awareness**: Antergos NeXT defaults to dinit but supports runit and s6. If shipping service files, consider providing them for all three. OpenRC is not supported.
- **Package order in profile.yaml**: In the ISO repo's `profile.yaml`, `calamares` must be listed before `calamares-branding-antergos-next` so branding files overwrite defaults.
- **`componentName` in `branding.desc` must match its directory name**. Calamares will bail if they don't match.

## Building packages locally

```bash
cd packages/<pkgname>
makepkg -si
```

## Getting help

Open an issue or ping the maintainer. If it's urgent, mention it. If it's not, be patient — I'll get to it.
