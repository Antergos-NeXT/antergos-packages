import QtQuick 2.15
import Qt5Compat.GraphicalEffects

Item {
    id: root
    width: 920
    height: 630

    function onActivate() {
        timer.restart()
        slider.reset()
    }

    function onLeave() {
    }

    Timer {
        id: timer
        interval: 12000
        running: true
        repeat: true
        onTriggered: slider.currentSlideIndex++
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            timer.restart()
            slider.currentSlideIndex++
        }
    }

    Image {
        id: background
        anchors.fill: parent
        source: "background.jpg"
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.55)
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.15) }
            GradientStop { position: 0.5; color: "transparent" }
            GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.3) }
        }
    }

    Rectangle {
        id: card
        width: 460
        height: 380
        radius: 12
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: 40
        color: "#2B2930"

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            radius: 40
            samples: 56
            color: Qt.rgba(0, 0, 0, 0.5)
        }

        Rectangle {
            anchors.fill: parent
            radius: 12
            color: "transparent"
            border { color: Qt.rgba(1, 1, 1, 0.04); width: 1 }
        }

        Item {
            anchors {
                fill: parent
                margins: 32
            }

            Slider {
                id: slider
                anchors.fill: parent
                slides: [
                    Dia {
                        title: qsTr("Welcome to Antergos NeXT Minimal")
                        body: qsTr("Arch Linux powered by Artix. Rolling release, dinit init, Xfce desktop, and the latest software.")
                        footer: qsTr("Choose your preferred desktop environment during setup")
                    },
                    Dia {
                        title: qsTr("Desktop Environments")
                        body: qsTr("Select from KDE Plasma, Xfce, Cinnamon, MATE, LXQt, i3, Sway, or Hyprland.")
                        footer: qsTr("A curated selection of the best Linux desktops")
                    },
                    Dia {
                        title: qsTr("Antergos Tools")
                        body: qsTr("Welcome app for system configuration, Calamares installer with offline and online modes, and full access to the AUR.")
                        footer: qsTr("Everything you need to get started")
                    },
                    Dia {
                        title: qsTr("Open Source")
                        body: qsTr("Free and open source software built by the community for the community.")
                        footer: qsTr("github.com/Antergos-NeXT")
                    },
                    Dia {
                        title: qsTr("Almost Done")
                        body: qsTr("Your system is being configured with your selected desktop environment, drivers, and applications.")
                        footer: qsTr("Reboot and enjoy Antergos NeXT")
                    }
                ]
            }
        }
    }

    Image {
        id: logo
        source: "antergos-logo.png"
        width: 140
        height: 40
        fillMode: Image.PreserveAspectFit
        anchors {
            bottom: parent.bottom
            bottomMargin: 20
            left: parent.left
            leftMargin: 24
        }
        opacity: 0.45
    }

    Row {
        anchors {
            bottom: parent.bottom
            bottomMargin: 20
            horizontalCenter: parent.horizontalCenter
        }
        spacing: 6

        Repeater {
            model: slider.slides.length

            Rectangle {
                width: index == slider.currentSlideIndex ? 22 : 7
                height: 7
                radius: 3.5
                color: index == slider.currentSlideIndex ? "#4A9EFF" : "#8E9099"
                opacity: index == slider.currentSlideIndex ? 1 : 0.35
                Behavior on width { NumberAnimation { duration: 250 } }
                Behavior on color { ColorAnimation { duration: 200 } }
            }
        }
    }
}
