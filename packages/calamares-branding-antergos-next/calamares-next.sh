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
    local pacmanlog_copy="$HOME/pacman-install.log"

    while true ; do
        sleep 2
        pacmanlog="$(/usr/bin/ls -1 /tmp/calamares-root-*/var/log/pacman.log 2>/dev/null | /usr/bin/tail -n 1)"
        if [ -n "$pacmanlog" ] ; then
            /usr/bin/cp "$pacmanlog" "$pacmanlog_copy"
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
    if [ "$EUID" = 0 ]; then
        calamares -D8 >> $log &
        return
    fi

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

    yad --info \
        --title="Notice" \
        --image=dialog-information \
        --borders=20 \
        --width=500 \
        --text="The so-called \"Offline Install\" has been removed.\n\nIt was never truly offline — all DE packages were\ndownloaded from the internet regardless. The rootfs\nonly contained live session essentials, so there was\nnothing meaningful to unpack.\n\nAll packages are now installed online via basestrap." \
        --button="Continue":0

    yad --form \
        --title="Antergos NeXT Installer" \
        --image="$ICO" \
        --borders=20 \
        --height=200 --width=480 \
        --buttons-layout=spread \
        --field=" ":LBL "" \
        --field="<b>Online Install</b>":LBL "" \
        --field="Full desktop selection from the internet.":LBL "" \
        --field="Choose your desktop environment, customize packages,":LBL "" \
        --field="get the latest updates.":LBL "" \
        --field=" ":LBL "" \
        --button="Install":0
}

InstallWithLogs() {
    InstallLog_Start
    Calamares_Start

    if [ "$ShowPacmanLog" = "TRUE" ] ; then
        CatchChrootedPacmanLog
    else
        sleep 5
    fi
}

SetConfig() {
    sudo rm -f "/etc/calamares/settings.conf"
    sudo cp "/etc/calamares-online/settings.conf" "/etc/calamares/settings.conf"
    PreLog "Using online settings"
}

PreLog() {
    echo "==> $1" >> "$prelogfile"
}

Main() {
    progname="${0##*/}"

    [ -x /usr/bin/calamares ] || GUIDIE "<tt>/usr/bin/calamares</tt> is needed for installing Antergos NeXT"

    local CurrentDesktop=""
    if [ "$XDG_CURRENT_DESKTOP" ]; then
        CurrentDesktop=$(echo "$XDG_CURRENT_DESKTOP" | tr '[:upper:]' '[:lower:]')
    elif [ "$DESKTOP_SESSION" ]; then
        CurrentDesktop=$(echo "$DESKTOP_SESSION" | tr '[:upper:]' '[:lower:]')
    fi

    local ShowInstallLog="FALSE"
    local ShowPacmanLog="TRUE"
    local Home=/home/antergos
    local log=$Home/antergos-install.log
    local workdir=""
    local prelogfile=""

    workdir="$Home/work.$progname.xyz"
    mkdir -p "$workdir"

    prelogfile="$workdir/preliminary.log"
    rm -f "$prelogfile"

    AskMode
    mode=online
    SetConfig
    InstallWithLogs
}

Main "$@"
