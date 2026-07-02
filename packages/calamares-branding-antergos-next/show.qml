import QtQuick 2.15;

Item {
    id: root

    function onActivate(){
        console.log("Slideshow) activated");
        timer.restart();
        slider.reset();
    }

    function onLeave(){
        console.log("Slideshow) deactivated");
    }

    width: 940
    height: 600

    Timer {
        id: timer
        interval: 10000
        running: true
        repeat: true
        onTriggered: slider.currentSlideIndex++
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            timer.restart();
            slider.currentSlideIndex++;
        }
    }

    Image {
        id: background
        anchors.fill: parent
        source: "background.jpg"
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        height: 200
        color: Qt.rgba(0, 0, 0, 0.6)

        Slider {
            id: slider
            anchors {
                fill: parent
                margins: 20
            }

            slides: [
                Dia {
                    title: qsTr("Welcome to Antergos NeXT")
                    body: qsTr("A modern Artix Linux experience with OpenRC and elogind")
                    footer: qsTr("Choose your preferred desktop environment during setup")
                },
                Dia {
                    title: qsTr("Desktop Environments")
                    body: qsTr("Select from KDE Plasma, Xfce, Cinnamon, MATE, LXQt, i3, Sway, or Hyprland")
                    footer: qsTr("Each desktop is fully configured and ready to use")
                },
                Dia {
                    title: qsTr("Antergos Tools")
                    body: qsTr("Welcome app for system configuration, Calamares installer with offline and online modes, and HAL package manager")
                    footer: qsTr("Full access to Artix Linux repositories and the AUR")
                },
                Dia {
                    title: qsTr("Open Source")
                    body: qsTr("Antergos NeXT is free and open source software built by the community")
                    footer: qsTr("Contribute on GitHub — Antergos-NeXT")
                },
                Dia {
                    title: qsTr("Almost Done")
                    body: qsTr("Your system is being configured with your selected options")
                    footer: qsTr("Reboot and enjoy Antergos NeXT")
                }
            ]
        }
    }
}
