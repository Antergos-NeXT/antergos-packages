import yaml
import subprocess
import os
import shutil
import glob
import sys

LOCAL_REPO = "/tmp/pkgout"

def repo_init():
    os.makedirs(LOCAL_REPO, exist_ok=True)
    conf_path = "/etc/pacman.conf"
    with open(conf_path) as f:
        conf = f.read()
    if "[antergos-local]" not in conf:
        with open(conf_path, "w") as f:
            f.write(conf.replace(
                "[core]",
                "[antergos-local]\nSigLevel = Never\nServer = file:///tmp/pkgout\n\n[core]"
            ))

def repo_add(pkg_path):
    db = f"{LOCAL_REPO}/antergos-local.db.tar.gz"
    subprocess.run(["repo-add", db, pkg_path], capture_output=True)

def repo_has(pkgname):
    db = f"{LOCAL_REPO}/antergos-local.db.tar.gz"
    if not os.path.exists(db):
        return False
    result = subprocess.run(
        ["bsdtar", "-tf", db],
        capture_output=True, text=True
    )
    return pkgname in result.stdout

with open("packages.yaml") as f:
    pkgs = yaml.safe_load(f)["packages"]

repo_init()

for pkg in pkgs:
    local_pkgbuild = f"packages/{pkg}/PKGBUILD"
    build_dir = f"/tmp/build-{pkg}"

    if os.path.exists(build_dir):
        shutil.rmtree(build_dir)

    if os.path.exists(local_pkgbuild):
        shutil.copytree(f"packages/{pkg}", build_dir)
    else:
        subprocess.run(["git", "clone", f"https://aur.archlinux.org/{pkg}.git", build_dir])

    subprocess.run(["chown", "-R", "builder:builder", build_dir])

    # Sync pacman so makepkg -s can resolve local packages
    subprocess.run(["pacman", "-Sy", "--noconfirm"], capture_output=True)

    result = subprocess.run(
        ["su", "-", "builder", "-c", f"cd {build_dir} && makepkg -s --noconfirm --noprogress --skippgpcheck --skipinteg"],
        capture_output=True, text=True
    )
    if result.returncode != 0:
        print(f"::error::BUILD FAILED: {pkg}")
        print(result.stdout[-500:])
        print(result.stderr[-500:])
        sys.exit(1)

    for pkg_file in glob.glob(f"{build_dir}/*.pkg.tar.zst"):
        shutil.copy(pkg_file, LOCAL_REPO)
        repo_add(pkg_file)

print("Done!")
