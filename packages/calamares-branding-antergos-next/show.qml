import QtQuick 2.15;

Item {
    id: root

    function onActivate(){
        console.log("Slideshow) activated");
        timer.restart();
        slider.reset();
        img.reset();
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
        onTriggered: slider.currentSlideIndex++,img.currentSlideIndex++
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            timer.restart();
            slider.currentSlideIndex++;
            img.currentSlideIndex++;
        }
    }

    Item {
        anchors.fill: parent
        Image {
            id: background
            anchors {
                fill: parent
                margins: -10
                bottomMargin: 0
            }

            source: "background.jpg"
            sourceSize.width: width
            sourceSize.height: height
        }

    }

    Slider {
        id: slider
        height: 50

        slides: [
            Dia {
                title: qsTr("Welcome to Antergos NeXT")
                body: qsTr("A modern Arch Linux experience built on EndeavourOS")
                footer: qsTr("Choose your preferred desktop environment during setup")
            },
            Dia {
                title: qsTr("Desktop Environments")
                body: qsTr("Select from KDE Plasma, GNOME, Xfce, Budgie, Cinnamon, MATE, LXQt, or i3/Sway")
                footer: qsTr("Each desktop is fully configured and ready to use")
            },
            Dia {
                title: qsTr("Antergos Tools")
                body: qsTr("Welcome app for system configuration, Calamares installer with offline and online modes, and HAL package manager")
                footer: qsTr("Full access to Arch Linux repositories and the AUR")
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
        anchors {
            centerIn: parent
            horizontalCenterOffset: 50
            verticalCenterOffset: 10
        }
    }
    Slider {
        id: img
        height: 50

        slides: [
            Dia {
                image: "antergos-logo.png"
            },
            Dia {
                image: "antergos-logo.png"
            },
            Dia {
                image: "antergos-logo.png"
            },
            Dia {
                image: "antergos-logo.png"
            },
            Dia {
                image: "antergos-logo.png"
            }
        ]
        anchors {
            centerIn: parent
            horizontalCenterOffset: -400
            verticalCenterOffset: -100
        }
    }
}
