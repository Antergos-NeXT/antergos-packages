/* Antergos NeXT Calamares slideshow */
import QtQuick 2.0;
import calamares.slideshow 1.0;

Presentation
{
    id: presentation

    Timer {
        interval: 8000
        running: presentation.activatedInCalamares
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }

    Slide {
        anchors.fill: parent

        Image {
            id: logo
            source: "antergos-logo.png"
            width: 320
            height: 92
            fillMode: Image.PreserveAspectFit
            anchors {
                centerIn: parent
                verticalCenterOffset: -40
            }
        }

        Text {
            anchors {
                top: logo.bottom
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
            text: "Welcome to Antergos NeXT"
            font.pixelSize: 22
            font.bold: true
            color: "#4A9EFF"
        }

        Text {
            anchors {
                top: parent.verticalCenter
                topMargin: 40
                horizontalCenter: parent.horizontalCenter
            }
            text: "A modern Arch Linux experience"
            font.pixelSize: 14
            color: "#7F8C8D"
        }
    }

    Slide {
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            color: "#F0F4F8"

            Text {
                anchors {
                    top: parent.top
                    topMargin: 30
                    horizontalCenter: parent.horizontalCenter
                }
                text: "Built on EndeavourOS"
                font.pixelSize: 20
                font.bold: true
                color: "#2C3E50"
            }

            Column {
                anchors {
                    centerIn: parent
                    verticalCenterOffset: 10
                }
                spacing: 12

                Text { text: "• EndeavourOS base — stable, rolling" ; font.pixelSize: 13 ; color: "#34495E" }
                Text { text: "• dracut initramfs — fast, reliable" ; font.pixelSize: 13 ; color: "#34495E" }
                Text { text: "• systemd — modern init system" ; font.pixelSize: 13 ; color: "#34495E" }
                Text { text: "• Latest Linux kernel and drivers" ; font.pixelSize: 13 ; color: "#34495E" }
                Text { text: "• Arch User Repository (AUR) access" ; font.pixelSize: 13 ; color: "#34495E" }
            }
        }
    }

    Slide {
        anchors.fill: parent

        Text {
            anchors {
                top: parent.top
                topMargin: 30
                horizontalCenter: parent.horizontalCenter
            }
            text: "Desktop Environments"
            font.pixelSize: 20
            font.bold: true
            color: "#2C3E50"
        }

        Column {
            anchors {
                centerIn: parent
                verticalCenterOffset: 10
            }
            spacing: 12

            Text { text: "• KDE Plasma — full-featured, customizable" ; font.pixelSize: 13 ; color: "#34495E" }
            Text { text: "• GNOME — modern, streamlined" ; font.pixelSize: 13 ; color: "#34495E" }
            Text { text: "• Xfce — lightweight, classic" ; font.pixelSize: 13 ; color: "#34495E" }
            Text { text: "• Budgie — elegant, simple" ; font.pixelSize: 13 ; color: "#34495E" }
            Text { text: "• i3/ Sway — tiling window managers" ; font.pixelSize: 13 ; color: "#34495E" }
        }
    }

    Slide {
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            color: "#F0F4F8"

            Text {
                anchors {
                    top: parent.top
                    topMargin: 30
                    horizontalCenter: parent.horizontalCenter
                }
                text: "Antergos Tools"
                font.pixelSize: 20
                font.bold: true
                color: "#2C3E50"
            }

            Column {
                anchors {
                    centerIn: parent
                    verticalCenterOffset: 10
                }
                spacing: 12

                Text { text: "• Welcome app — system info & quick config" ; font.pixelSize: 13 ; color: "#34495E" }
                Text { text: "• Calamares installer — easy setup" ; font.pixelSize: 13 ; color: "#34495E" }
                Text { text: "• Cnchi — classic Antergos installer" ; font.pixelSize: 13 ; color: "#34495E" }
                Text { text: "• Pacman + AUR helper — full package access" ; font.pixelSize: 13 ; color: "#34495E" }
                Text { text: "• Online documentation and community" ; font.pixelSize: 13 ; color: "#34495E" }
            }
        }
    }

    Slide {
        anchors.fill: parent

        Text {
            anchors {
                top: parent.top
                topMargin: 60
                horizontalCenter: parent.horizontalCenter
            }
            text: "Finishing Installation..."
            font.pixelSize: 22
            font.bold: true
            color: "#4A9EFF"
        }

        Image {
            source: "antergos-icon.png"
            width: 96
            height: 96
            fillMode: Image.PreserveAspectFit
            anchors {
                centerIn: parent
                verticalCenterOffset: 10
            }
        }

        Text {
            anchors {
                bottom: parent.bottom
                bottomMargin: 40
                horizontalCenter: parent.horizontalCenter
            }
            text: "Almost there — your system is being configured"
            font.pixelSize: 13
            color: "#7F8C8D"
        }
    }

    Slide {
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            color: "#20252B"

            Text {
                anchors {
                    centerIn: parent
                    verticalCenterOffset: -30
                }
                text: "Thank You!"
                font.pixelSize: 28
                font.bold: true
                color: "#4A9EFF"
            }

            Text {
                anchors {
                    top: parent.verticalCenter
                    topMargin: 10
                    horizontalCenter: parent.horizontalCenter
                }
                text: "Antergos NeXT is ready.<br/>Reboot and enjoy!"
                font.pixelSize: 14
                color: "#C8D6E5"
                horizontalAlignment: Text.Center
            }
        }
    }

    function onActivate() {
        presentation.currentSlide = 0
    }

    function onLeave() {}
}
