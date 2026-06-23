#!/bin/bash

# Antergos NeXT Calamares Installer Launcher

GUIDIE() {
    echo "calamares-next: $1" | sed -e 's|<tt>||g' -e 's|</tt>||g'

    local prog=yad
    command -v yad &>/dev/null || prog=zenity

    local cmd=(
        "$prog" --form --title="Error detected"
        --text="<b>calamares-next:</b>\n$1\n"
        --image=dialog-error
        --button=yad-quit:1
    )
    "${cmd[@]}"
    exit 1
}

FollowFile() {
    local tailfile="$1"
    local term_title="$2"
    local xpos="$3"
    local ypos="$4"

    case "$CurrentDesktop" in
        xfce) xfce4-terminal -T "$term_title" --geometry="120x20+$xpos+$ypos" -x tail -f "$tailfile" & ;;
        kde) setsid konsole -e tail -f "$tailfile" &> /dev/null ;;
    esac
}

CatchChrootedPacmanLog() {
    local pacmanlog=""
    local lockfile="$HOME/.$progname.lck"

    while true ; do
        sleep 2
        pacmanlog="$(/usr/bin/ls -1 /tmp/calamares-root-*/var/log/pacman.log 2>/dev/null | /usr/bin/tail -n 1)"
        if [ -n "$pacmanlog" ] ; then
            [ -r "$lockfile" ] && return
            /usr/bin/touch "$lockfile"
            FollowFile "$pacmanlog" "Pacman log" 400 50
            break
        fi
    done
}

LogHeader() {
    local calamares_version date
    calamares_version="$(pacman -Q calamares 2>/dev/null | awk '{print $NF}')"
    date=$(date -u "+%x %X")

    cat <<EOF > $log
########## $log by calamares-next
########## Started (UTC): $date
########## Install mode: $mode
########## Calamares version: $calamares_version
EOF
}

InstallLog_Start() {
    LogHeader

    if [ "$ShowInstallLog" = "TRUE" ] ; then
        FollowFile "$log" "Install log" 20 20
    fi
}

Calamares_Start() {
    local kdesu=/usr/lib/kf6/kdesu
    [ -x $kdesu ] || kdesu=kdesu

    case "$CurrentDesktop" in
        kde) $kdesu -t -c "calamares -D8" >> $log & ;;
        *)   pkexec calamares -D8 >> $log & ;;
    esac
}

AskMode() {
    local ICO="/usr/share/calamares/branding/antergos-next/antergos-icon.png"
    [ -f "$ICO" ] || ICO="system-software-install"

    if [ "$has_connection" = yes ] ; then
        yad --form \
            --title="Antergos NeXT Installer" \
            --image="$ICO" \
            --borders=20 \
            --height=250 --width=520 \
            --buttons-layout=spread \
            --field=" ":LBL "" \
            --field="<b>Online Install</b>":LBL "" \
            --field="Full desktop selection from the internet.":LBL "" \
            --field="Choose your desktop environment, customize packages,":LBL "" \
            --field="get the latest updates.":LBL "" \
            --field=" ":LBL "" \
            --field="<b>Offline Install</b>":LBL "" \
            --field="Quick install from the live ISO.":LBL "" \
            --field="Install GNOME desktop directly from the ISO.":LBL "" \
            --field="No internet required.":LBL "" \
            --field=" ":LBL "" \
            --button="Offline":13 \
            --button="Online":11
    else
        yad --form \
            --title="Antergos NeXT Installer" \
            --image="$ICO" \
            --borders=20 \
            --height=200 --width=520 \
            --buttons-layout=spread \
            --field=" ":LBL "" \
            --field="<b>Offline Install</b>":LBL "" \
            --field="Quick install from the live ISO.":LBL "" \
            --field="Install GNOME desktop directly from the ISO.":LBL "" \
            --field=" ":LBL "" \
            --button="Offline":13
    fi
}

InstallWithLogs() {
    InstallLog_Start
    Calamares_Start

    if [ "$ShowPacmanLog" = "FALSE" ] ; then
        sleep 5
        return
    fi

    case "$mode" in
        online)  CatchChrootedPacmanLog ;;
        offline) CatchChrootedPacmanLog ;;
    esac
}

SetConfig() {
    case "$mode" in
        online)
            sudo cp "/etc/calamares-online/settings.conf" "/etc/calamares/settings.conf"
            PreLog "Using online settings"
            ;;
        offline)
            sudo cp "/etc/calamares-offline/settings.conf" "/etc/calamares/settings.conf"
            PreLog "Using offline settings"
            ;;
    esac
}

PreLog() {
    echo "==> $1" >> "$prelogfile"
}

Main() {
    progname="${0##*/}"
    has_connection=no
    show_mode=yes

    [ -x /usr/bin/calamares ] || GUIDIE "<tt>/usr/bin/calamares</tt> is needed for installing Antergos NeXT"

    ping -c 1 -W 2 archlinux.org &>/dev/null && has_connection=yes

    local CurrentDesktop=""
    if [ "$XDG_CURRENT_DESKTOP" ]; then
        CurrentDesktop=$(echo "$XDG_CURRENT_DESKTOP" | tr '[:upper:]' '[:lower:]')
    elif [ "$DESKTOP_SESSION" ]; then
        CurrentDesktop=$(echo "$DESKTOP_SESSION" | tr '[:upper:]' '[:lower:]')
    fi

    local ShowInstallLog="FALSE"
    local ShowPacmanLog="FALSE"
    local Home=/home/liveuser
    local log=$Home/antergos-install.log
    local cfolder=/etc/calamares
    local workdir=""
    local prelogfile=""

    workdir="$Home/work.$progname.xyz"
    mkdir -p "$workdir"

    prelogfile="$workdir/preliminary.log"
    rm -f "$prelogfile"

    if [ "$show_mode" = yes ] ; then
        AskMode
        ret=$?
        case $ret in
            11) mode=online ;;
            13) mode=offline ;;
            *)  exit $ret ;;
        esac
    else
        mode=offline
    fi

    case "$mode" in
        online|offline)
            SetConfig
            InstallWithLogs
            ;;
        *)
            GUIDIE "unsupported mode '$mode'"
            ;;
    esac
}

Main "$@"
