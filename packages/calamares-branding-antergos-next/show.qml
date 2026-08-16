import QtQml 2.15
import QtQuick 2.15

Item {
    id: root

    Component.onCompleted: onActivate()

    function onActivate() {
        timer.restart()
        slider.reset()
        artwork.state = "nearGround"
    }

    function onLeave() {
    }

    width: 920
    height: 630

    Timer {
        id: timer
        interval: 20000
        running: false
        repeat: true
        onTriggered: slider.currentSlideIndex++
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            timer.restart()
            slider.currentSlideIndex++
        }
    }

    Artwork {
        id: artwork
        anchors.fill: parent
    }

    Slider {
        id: slider
        height: 50
        slides: [
            Slide {
                title: qsTr("Welcome to Antergos NeXT")
                secondaryTitle: qsTr("Artix Linux, dinit init")
                body: qsTr("A rolling-release distribution built for performance, simplicity, and choice. Select your desktop, customize your experience, and enjoy a system that's truly yours.")
                footer: qsTr("Click or tap to advance")
            },
            Slide {
                title: qsTr("Desktop Environments")
                secondaryTitle: qsTr("Ten options to choose from")
                body: qsTr("Plasma, Plasma (Minimal), Xfce, Cinnamon, MATE, LXQt, i3, Sway, Hyprland, or COSMIC — pick the environment that fits your workflow during installation.")
            },
            Slide {
                title: qsTr("Init System")
                secondaryTitle: qsTr("dinit by default")
                body: qsTr("Fast, parallel service boot with dinit. runit and s6 are also available for selection during online installation.")
            },
            Slide {
                title: qsTr("Installation Modes")
                secondaryTitle: qsTr("Online by default")
                body: qsTr("All packages are installed online from the Artix and Antergos NeXT repositories, so you always get the latest versions. Choose your DE, DM, and additional packages during installation.")
            },
            Slide {
                title: qsTr("Built on Artix Linux")
                secondaryTitle: qsTr("Rolling, stable, lightweight")
                body: qsTr("Access to the Artix and Arch Linux repositories. Full AUR support. The latest packages without the bloat.")
            },
            Slide {
                title: qsTr("Thank You")
                secondaryTitle: qsTr("Your installation is in progress")
                body: qsTr("Sit back and relax while your system is being configured. We hope you enjoy Antergos NeXT.")
                footer: qsTr("github.com/Antergos-NeXT")
            }
        ]

        anchors {
            centerIn: parent
            horizontalCenterOffset: -100
            verticalCenterOffset: -57
        }
    }
}
