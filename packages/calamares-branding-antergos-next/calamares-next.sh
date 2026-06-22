#!/bin/bash
# Antergos NeXT Installer Launcher
# Presents offline/online choice and launches Calamares with the right config

set -e

# Prefer zenity (GTK), fall back to dialog (curses)
if command -v zenity &>/dev/null; then
    DIALOG="zenity"
elif command -v kdialog &>/dev/null; then
    DIALOG="kdialog"
else
    DIALOG=""
fi

# Check for internet connectivity
check_net() {
    ping -c 1 -W 2 archlinux.org &>/dev/null
}

CHOICE=""
if [ -n "$DIALOG" ]; then
    if [ "$DIALOG" = "zenity" ]; then
        CHOICE=$(zenity --list \
            --title="Antergos NeXT Installer" \
            --text="Choose installation mode:" \
            --width=500 --height=300 \
            --column="Mode" --column="Description" \
            "Offline" "Install GNOME desktop from the live ISO. No internet required." \
            "Online" "Choose a desktop environment and install from the internet.")
    else
        CHOICE=$(kdialog --menu "Antergos NeXT Installer\nChoose installation mode:" \
            "Offline" "Install GNOME desktop from the live ISO. No internet required." \
            "Online" "Choose a desktop environment and install from the internet.")
    fi
else
    echo "Antergos NeXT Installer"
    echo "======================"
    echo "1) Offline — Install GNOME from ISO (no internet)"
    echo "2) Online — Choose DE and install from internet"
    echo ""
    read -rp "Choice [1]: " n
    case "$n" in
        2|online|Online) CHOICE="Online" ;;
        *) CHOICE="Offline" ;;
    esac
fi

case "$CHOICE" in
    "Online")
        # Online mode: use netinstall for DE selection, no unpackfs
        if ! check_net; then
            if [ -n "$DIALOG" ]; then
                "$DIALOG" --error --text="No internet connection detected.\n\nOnline installation requires a working network connection.\nPlease connect to the internet and try again."
            fi
            exit 1
        fi
        exec calamares -c /etc/calamares-online
        ;;
    *)
        # Offline mode: use unpackfs with GNOME squashfs
        exec calamares -c /etc/calamares-offline
        ;;
esac
