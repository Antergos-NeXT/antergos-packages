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
                        title: qsTr("Welcome to Antergos NeXT")
                        body: qsTr("Artix Linux, dinit init, rolling release.")
                        footer: qsTr("Choose your desktop environment during setup")
                    },
                    Dia {
                        title: qsTr("Desktop Environments")
                        body: qsTr("Plasma, Xfce, Cinnamon, MATE, LXQt, i3, Sway, Hyprland, COSMIC.")
                        footer: qsTr("A curated selection — pick your favorite")
                    },
                    Dia {
                        title: qsTr("Init System")
                        body: qsTr("dinit — fast, parallel service boot. Optional runit and s6 available.")
                        footer: qsTr("Modern init, modern system")
                    },
                    Dia {
                        title: qsTr("Two Installer Modes")
                        body: qsTr("Online: full DE, DM, and package selection. Offline: Plasma pre-configured, ready to go.")
                        footer: qsTr("You choose how you install")
                    },
                    Dia {
                        title: qsTr("Features")
                        body: qsTr("Full AUR access. KDE Plasma live session. Calamares installer. Latest packages from Artix repos.")
                        footer: qsTr("Everything you need, nothing you don't")
                    },
                    Dia {
                        title: qsTr("Open Source")
                        body: qsTr("Built by the community. Transparent, free, and always will be.")
                        footer: qsTr("github.com/Antergos-NeXT")
                    },
                    Dia {
                        title: qsTr("Almost Done")
                        body: qsTr("Your system is being configured with your selected desktop and packages.")
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
